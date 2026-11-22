package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import util.DBConnection;
import service.PricingService;

/**
 * Creates the order, order items, and stock changes in ONE database
 * transaction. The user's cart row is locked first, matching CartServiceDAO.
 */
public class CheckoutDAO {

    private static final Logger LOGGER = Logger.getLogger(CheckoutDAO.class.getName());
    private final PricingService pricingService = new PricingService();

    public enum Status {
        SUCCESS,
        EMPTY_CART,
        PRODUCT_UNAVAILABLE,
        INSUFFICIENT_STOCK,
        DATABASE_ERROR
    }

    public static final class CheckoutResult {
        private final Status status;
        private final Long orderId;
        private final String message;

        public CheckoutResult(Status status, Long orderId, String message) {
            this.status = status;
            this.orderId = orderId;
            this.message = message;
        }

        public Status getStatus() {
            return status;
        }

        public Long getOrderId() {
            return orderId;
        }

        public String getMessage() {
            return message;
        }

        public boolean isSuccessful() {
            return status == Status.SUCCESS;
        }
    }

    private static final class CheckoutLine {
        private long productId;
        private String productName;
        private int quantity;
        private int availableStock;
        private boolean active;
        private boolean productExists;
        private BigDecimal unitPrice; // Base retail price
        private BigDecimal finalUnitPrice; // One server-resolved price, persisted to orderitem
        
        // Special Sale fields for secure server-side calculation
        private boolean specialSale;
        private String discountType;
        private BigDecimal discountValue;
        private LocalDateTime saleStartDate;
        private LocalDateTime saleEndDate;

        // Secure effective price calculation method matching Product entity logic
        public BigDecimal getEffectiveUnitPrice() {
            if (!specialSale || discountType == null || discountValue == null || unitPrice == null) {
                return unitPrice;
            }
            
            LocalDateTime now = LocalDateTime.now();
            if (saleStartDate != null && now.isBefore(saleStartDate)) return unitPrice;
            if (saleEndDate != null && now.isAfter(saleEndDate)) return unitPrice;

            if ("PERCENT".equals(discountType)) {
                BigDecimal discountFactor = BigDecimal.ONE.subtract(discountValue.divide(BigDecimal.valueOf(100), 4, java.math.RoundingMode.HALF_UP));
                return unitPrice.multiply(discountFactor).setScale(2, java.math.RoundingMode.HALF_UP);
            } else if ("FIXED".equals(discountType)) {
                BigDecimal discounted = unitPrice.subtract(discountValue);
                return discounted.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : discounted.setScale(2, java.math.RoundingMode.HALF_UP);
            }
            return unitPrice;
        }
    }

    public CheckoutResult checkout(Long userId, String city, String township,
                                    String street, String description) {
        if (city == null || !"Mandalay".equalsIgnoreCase(city.trim())
                || township == null || township.trim().isEmpty()
                || street == null || street.trim().isEmpty()
                || township.trim().length() > 100 || street.trim().length() > 255
                || (description != null && description.trim().length() > 500)) {
            return new CheckoutResult(Status.DATABASE_ERROR, null,
                    "Please enter a valid Mandalay shipping address.");
        }
        if (userId == null) {
            return new CheckoutResult(Status.DATABASE_ERROR, null,
                    "Your session has expired. Please sign in again.");
        }

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            try {
                Long cartId = lockCart(con, userId);
                if (cartId == null) {
                    con.rollback();
                    return new CheckoutResult(Status.EMPTY_CART, null,
                            "Your cart is empty. Add products before placing an order.");
                }

                List<CheckoutLine> lines = loadCartForUpdate(con, cartId);
                if (lines.isEmpty()) {
                    con.rollback();
                    return new CheckoutResult(Status.EMPTY_CART, null,
                            "Your cart is empty. Add products before placing an order.");
                }

                BigDecimal total = BigDecimal.ZERO;
                for (CheckoutLine line : lines) {
                    if (!line.productExists || !line.active || line.unitPrice == null) {
                        con.rollback();
                        return new CheckoutResult(Status.PRODUCT_UNAVAILABLE, null,
                                "A product in your cart is no longer available. Please review your cart.");
                    }
                    if (line.quantity <= 0) {
                        con.rollback();
                        return new CheckoutResult(Status.DATABASE_ERROR, null,
                                "Your cart contains an invalid quantity. Please contact support.");
                    }
                    if (line.availableStock < line.quantity) {
                        con.rollback();
                        return new CheckoutResult(Status.INSUFFICIENT_STOCK, null,
                                "Not enough stock for \"" + line.productName
                                        + "\". Available quantity: " + line.availableStock + ".");
                    }

                    // Resolve the final price once per line. PricingService applies:
                    // eligible wholesale tier -> active special sale -> retail price.
                    // Reuse this exact value for both the order total and orderitem.price.
                    line.finalUnitPrice = resolveLinePrice(con, userId, line);
                    total = total.add(line.finalUnitPrice.multiply(BigDecimal.valueOf(line.quantity)));
                }

                String orderType = isApprovedWholesaleCustomer(con, userId) ? "WHOLESALE" : "RETAIL";
                long orderId = insertOrder(con, userId, total, orderType, city.trim(), township.trim(), street.trim(), description == null ? "" : description.trim());

                for (CheckoutLine line : lines) {
                    // Conditional update is a final safeguard against overselling.
                    String stockSql =
                            "UPDATE product SET stock = stock - ? "
                            + "WHERE id = ? AND active = 1 AND stock >= ?";
                    try (PreparedStatement ps = con.prepareStatement(stockSql)) {
                        ps.setInt(1, line.quantity);
                        ps.setLong(2, line.productId);
                        ps.setInt(3, line.quantity);
                        if (ps.executeUpdate() != 1) {
                            con.rollback();
                            return new CheckoutResult(Status.INSUFFICIENT_STOCK, null,
                                    "Stock changed while checking out. Please review your cart and try again.");
                        }
                    }

                    String itemSql =
                            "INSERT INTO orderitem (order_id, product_id, qty, price) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement ps = con.prepareStatement(itemSql)) {
                        ps.setLong(1, orderId);
                        ps.setLong(2, line.productId);
                        ps.setInt(3, line.quantity);
                        ps.setBigDecimal(4, line.finalUnitPrice);
                        ps.executeUpdate();
                    }
                }

                String clearCartSql = "DELETE FROM cartitem WHERE cart_id = ?";
                try (PreparedStatement ps = con.prepareStatement(clearCartSql)) {
                    ps.setLong(1, cartId);
                    int deleted = ps.executeUpdate();
                    if (deleted != lines.size()) {
                        con.rollback();
                        return new CheckoutResult(Status.DATABASE_ERROR, null,
                                "The cart changed during checkout. Please try again.");
                    }
                }

                con.commit();
                return new CheckoutResult(Status.SUCCESS, orderId,
                        "Your order has been placed successfully.");

            } catch (SQLException ex) {
                rollbackQuietly(con);
                throw ex;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Checkout transaction failed", ex);
            return new CheckoutResult(Status.DATABASE_ERROR, null,
                    "We could not place your order. No stock or cart changes were saved. Please try again.");
        }
    }


    /**
     * Cancels an order and restores its quantities to stock in one transaction.
     * Repeated cancellation is safe: an already-cancelled order is not restocked twice.
     */
    public boolean cancelOrderAndRestock(Long orderId) {
        if (orderId == null) {
            return false;
        }

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                String lockOrderSql = "SELECT status FROM `order` WHERE id = ? FOR UPDATE";
                String currentStatus;
                try (PreparedStatement ps = con.prepareStatement(lockOrderSql)) {
                    ps.setLong(1, orderId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            return false;
                        }
                        currentStatus = rs.getString("status");
                    }
                }

                if ("cancelled".equalsIgnoreCase(currentStatus)) {
                    con.commit();
                    return true;
                }
                if ("delivered".equalsIgnoreCase(currentStatus)) {
                    con.rollback();
                    return false;
                }

                // Do not release inventory for a paid order until a refund flow exists.
                String paidPaymentSql =
                        "SELECT id FROM payment WHERE order_id = ? "
                        + "AND UPPER(payment_status) = 'COMPLETED' LIMIT 1 FOR UPDATE";
                try (PreparedStatement ps = con.prepareStatement(paidPaymentSql)) {
                    ps.setLong(1, orderId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            con.rollback();
                            return false;
                        }
                    }
                }

                java.util.Map<Long, Integer> quantities = new java.util.LinkedHashMap<>();
                String itemsSql =
                        "SELECT product_id, qty FROM orderitem WHERE order_id = ? ORDER BY product_id FOR UPDATE";
                try (PreparedStatement ps = con.prepareStatement(itemsSql)) {
                    ps.setLong(1, orderId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            long productId = rs.getLong("product_id");
                            int qty = rs.getInt("qty");
                            if (qty <= 0) {
                                con.rollback();
                                return false;
                            }
                            quantities.merge(productId, qty, Integer::sum);
                        }
                    }
                }

                for (java.util.Map.Entry<Long, Integer> entry : quantities.entrySet()) {
                    String restockSql = "UPDATE product SET stock = stock + ? WHERE id = ?";
                    try (PreparedStatement ps = con.prepareStatement(restockSql)) {
                        ps.setInt(1, entry.getValue());
                        ps.setLong(2, entry.getKey());
                        if (ps.executeUpdate() != 1) {
                            con.rollback();
                            return false;
                        }
                    }
                }

                String updateOrderSql = "UPDATE `order` SET status = 'cancelled' WHERE id = ?";
                try (PreparedStatement ps = con.prepareStatement(updateOrderSql)) {
                    ps.setLong(1, orderId);
                    if (ps.executeUpdate() != 1) {
                        con.rollback();
                        return false;
                    }
                }

                con.commit();
                return true;
            } catch (SQLException ex) {
                rollbackQuietly(con);
                throw ex;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not cancel order and restore stock", ex);
            return false;
        }
    }

    private BigDecimal resolveLinePrice(Connection con, Long userId, CheckoutLine line) throws SQLException {
        return pricingService.resolvePrice(con, userId, line.productId, line.quantity, line.unitPrice,
                line.specialSale, line.discountType, line.discountValue, line.saleStartDate, line.saleEndDate);
    }

    private Long lockCart(Connection con, Long userId) throws SQLException {
        String sql = "SELECT id FROM cart WHERE user_id = ? FOR UPDATE";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong("id") : null;
            }
        }
    }

    private List<CheckoutLine> loadCartForUpdate(Connection con, Long cartId) throws SQLException {
        List<CheckoutLine> lines = new ArrayList<>();

        String sql = "SELECT ci.product_id, ci.qty, p.id AS found_product_id, "
                + "p.name, p.price, p.stock, p.active, "
                + "p.is_special_sale, p.discount_type, p.discount_value, "
                + "p.sale_start_date, p.sale_end_date "
                + "FROM cartitem ci LEFT JOIN product p ON p.id = ci.product_id "
                + "WHERE ci.cart_id = ? ORDER BY ci.product_id FOR UPDATE";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CheckoutLine line = new CheckoutLine();
                    line.productId = rs.getLong("product_id");
                    line.quantity = rs.getInt("qty");

                    long foundId = rs.getLong("found_product_id");
                    line.productExists = !rs.wasNull();

                    if (line.productExists) {
                        line.productName = rs.getString("name");
                        line.unitPrice = rs.getBigDecimal("price");
                        line.availableStock = rs.getInt("stock");
                        line.active = rs.getBoolean("active");
                        
                        // Map special sale attributes safely
                        line.specialSale = rs.getBoolean("is_special_sale");
                        line.discountType = rs.getString("discount_type");
                        line.discountValue = rs.getBigDecimal("discount_value");
                        
                        Timestamp startTs = rs.getTimestamp("sale_start_date");
                        if (startTs != null) line.saleStartDate = startTs.toLocalDateTime();
                        
                        Timestamp endTs = rs.getTimestamp("sale_end_date");
                        if (endTs != null) line.saleEndDate = endTs.toLocalDateTime();
                        
                    } else {
                        line.productName = "Product #" + line.productId;
                    }
                    lines.add(line);
                }
            }
        }
        return lines;
    }


    /** Determine order classification from the customer's approved application.
     * The browser cannot choose or override this value.
     */
    private boolean isApprovedWholesaleCustomer(Connection con, Long userId) throws SQLException {
        String sql = "SELECT 1 FROM wholesale_application WHERE user_id = ? AND UPPER(TRIM(status)) = 'APPROVED' LIMIT 1";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private long insertOrder(Connection con, Long userId, BigDecimal total, String orderType,
                             String city, String township, String street, String description) throws SQLException {
        String sql = "INSERT INTO `order` (user_id, orderDate, status, totalAmount, order_type, shipping_city, shipping_township, shipping_street, shipping_description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, userId);
            ps.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(3, "pending");
            ps.setBigDecimal(4, total);
            ps.setString(5, orderType);
            ps.setString(6, city);
            ps.setString(7, township);
            ps.setString(8, street);
            ps.setString(9, description);

            if (ps.executeUpdate() != 1) {
                throw new SQLException("Order header was not inserted.");
            }

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                }
            }
        }
        throw new SQLException("Database did not return a generated order ID.");
    }

    private void rollbackQuietly(Connection con) {
        try {
            con.rollback();
        } catch (SQLException rollbackError) {
            LOGGER.log(Level.SEVERE, "Could not roll back checkout transaction", rollbackError);
        }
    }
}
