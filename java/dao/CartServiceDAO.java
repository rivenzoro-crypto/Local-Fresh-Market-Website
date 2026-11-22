package dao;

import java.math.BigDecimal;	
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import util.DBConnection;
import service.PricingService;
import java.time.LocalDateTime;

/**
 * All cart mutations are scoped to the authenticated user's cart and run in
 * their own transaction. The cart row is locked first, matching CheckoutDAO.
 */
public class CartServiceDAO {
    private static final Logger LOGGER = Logger.getLogger(CartServiceDAO.class.getName());
    private final PricingService pricingService = new PricingService();

    public enum AddResult {
        ADDED, PRODUCT_NOT_FOUND, PRODUCT_INACTIVE, OUT_OF_STOCK,
        STOCK_LIMIT_REACHED, DATABASE_ERROR
    }

    public enum MutationStatus {
        UPDATED, REMOVED, RESTORED, NOT_FOUND, PRODUCT_INACTIVE,
        STOCK_LIMIT_REACHED, OUT_OF_STOCK, DATABASE_ERROR
    }

    public static final class MutationResult {
        private final MutationStatus status;
        private final Long productId;
        private final Integer quantity;

        public MutationResult(MutationStatus status, Long productId, Integer quantity) {
            this.status = status;
            this.productId = productId;
            this.quantity = quantity;
        }
        public MutationStatus getStatus() { return status; }
        public Long getProductId() { return productId; }
        public Integer getQuantity() { return quantity; }
    }

    public AddResult addOneToCart(Long userId, Long productId) {
        if (userId == null || productId == null || userId <= 0 || productId <= 0) {
            return AddResult.DATABASE_ERROR;
        }

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long cartId = lockOrCreateCart(con, userId);
                ProductRow product = lockProduct(con, productId);
                if (product == null) return rollbackAdd(con, AddResult.PRODUCT_NOT_FOUND);
                if (!product.active) return rollbackAdd(con, AddResult.PRODUCT_INACTIVE);
                if (product.stock <= 0) return rollbackAdd(con, AddResult.OUT_OF_STOCK);

                long itemId = 0;
                int currentQty = 0;
                String itemSql = "SELECT id, qty FROM cartitem WHERE cart_id = ? AND product_id = ? FOR UPDATE";
                try (PreparedStatement ps = con.prepareStatement(itemSql)) {
                    ps.setLong(1, cartId);
                    ps.setLong(2, productId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            itemId = rs.getLong("id");
                            currentQty = rs.getInt("qty");
                        }
                    }
                }

                int newQty = currentQty + 1;
                if (newQty > product.stock) return rollbackAdd(con, AddResult.STOCK_LIMIT_REACHED);

                if (itemId == 0) {
                    String insert = "INSERT INTO cartitem (cart_id, product_id, qty, price) VALUES (?, ?, 1, ?)";
                    try (PreparedStatement ps = con.prepareStatement(insert)) {
                        ps.setLong(1, cartId);
                        ps.setLong(2, productId);
                        ps.setBigDecimal(3, resolveCurrentPrice(con, userId, productId, 1, product));
                        ps.executeUpdate();
                    }
                } else {
                    String update = "UPDATE cartitem SET qty = ?, price = ? WHERE id = ? AND cart_id = ?";
                    try (PreparedStatement ps = con.prepareStatement(update)) {
                        ps.setInt(1, newQty);
                        ps.setBigDecimal(2, resolveCurrentPrice(con, userId, productId, newQty, product));
                        ps.setLong(3, itemId);
                        ps.setLong(4, cartId);
                        if (ps.executeUpdate() != 1) return rollbackAdd(con, AddResult.DATABASE_ERROR);
                    }
                }
                con.commit();
                return AddResult.ADDED;
            } catch (SQLException ex) {
                rollbackQuietly(con);
                throw ex;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not add product to cart", ex);
            return AddResult.DATABASE_ERROR;
        }
    }

    /** Adds a requested quantity in one transaction and recalculates the price for the final quantity. */
    public AddResult addQuantityToCart(Long userId, Long productId, int quantity) {
        if (userId == null || productId == null || userId <= 0 || productId <= 0 || quantity <= 0) {
            return AddResult.DATABASE_ERROR;
        }
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long cartId = lockOrCreateCart(con, userId);
                ProductRow product = lockProduct(con, productId);
                if (product == null) return rollbackAdd(con, AddResult.PRODUCT_NOT_FOUND);
                if (!product.active) return rollbackAdd(con, AddResult.PRODUCT_INACTIVE);
                if (product.stock <= 0) return rollbackAdd(con, AddResult.OUT_OF_STOCK);

                long itemId = 0;
                int currentQty = 0;
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT id, qty FROM cartitem WHERE cart_id=? AND product_id=? FOR UPDATE")) {
                    ps.setLong(1, cartId);
                    ps.setLong(2, productId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) { itemId = rs.getLong("id"); currentQty = rs.getInt("qty"); }
                    }
                }

                int newQty = currentQty + quantity;
                if (newQty > product.stock) return rollbackAdd(con, AddResult.STOCK_LIMIT_REACHED);
                BigDecimal unitPrice = resolveCurrentPrice(con, userId, productId, newQty, product);

                if (itemId == 0) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO cartitem (cart_id, product_id, qty, price) VALUES (?, ?, ?, ?)")) {
                        ps.setLong(1, cartId); ps.setLong(2, productId);
                        ps.setInt(3, newQty); ps.setBigDecimal(4, unitPrice);
                        ps.executeUpdate();
                    }
                } else {
                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE cartitem SET qty=?, price=? WHERE id=? AND cart_id=?")) {
                        ps.setInt(1, newQty); ps.setBigDecimal(2, unitPrice);
                        ps.setLong(3, itemId); ps.setLong(4, cartId);
                        if (ps.executeUpdate() != 1) return rollbackAdd(con, AddResult.DATABASE_ERROR);
                    }
                }
                con.commit();
                return AddResult.ADDED;
            } catch (SQLException ex) {
                rollbackQuietly(con);
                throw ex;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not bulk add product to cart", ex);
            return AddResult.DATABASE_ERROR;
        }
    }

    /** delta must be +1 or -1. Decrementing quantity one removes the item. */
    public MutationResult changeQuantity(Long userId, Long cartItemId, int delta) {
        if (userId == null || cartItemId == null || userId <= 0 || cartItemId <= 0
                || (delta != 1 && delta != -1)) {
            return result(MutationStatus.NOT_FOUND, null, null);
        }
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Long cartId = lockExistingCart(con, userId);
                if (cartId == null) return rollbackMutation(con, MutationStatus.NOT_FOUND, null, null);

                long productId;
                int currentQty;
                String itemSql = "SELECT product_id, qty FROM cartitem WHERE id = ? AND cart_id = ? FOR UPDATE";
                try (PreparedStatement ps = con.prepareStatement(itemSql)) {
                    ps.setLong(1, cartItemId);
                    ps.setLong(2, cartId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) return rollbackMutation(con, MutationStatus.NOT_FOUND, null, null);
                        productId = rs.getLong("product_id");
                        currentQty = rs.getInt("qty");
                    }
                }

                if (delta < 0 && currentQty <= 1) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "DELETE FROM cartitem WHERE id = ? AND cart_id = ?")) {
                        ps.setLong(1, cartItemId);
                        ps.setLong(2, cartId);
                        if (ps.executeUpdate() != 1) return rollbackMutation(con, MutationStatus.NOT_FOUND, null, null);
                    }
                    con.commit();
                    return result(MutationStatus.REMOVED, productId, currentQty);
                }

                ProductRow product = lockProduct(con, productId);
                if (delta > 0) {
                    if (product == null) return rollbackMutation(con, MutationStatus.NOT_FOUND, productId, currentQty);
                    if (!product.active) return rollbackMutation(con, MutationStatus.PRODUCT_INACTIVE, productId, currentQty);
                    if (currentQty + 1 > product.stock) {
                        return rollbackMutation(con, MutationStatus.STOCK_LIMIT_REACHED, productId, currentQty);
                    }
                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE cartitem SET qty = ?, price = ? WHERE id = ? AND cart_id = ?")) {
                        ps.setInt(1, currentQty + 1);
                        ps.setBigDecimal(2, resolveCurrentPrice(con, userId, productId, currentQty + 1, product));
                        ps.setLong(3, cartItemId);
                        ps.setLong(4, cartId);
                        if (ps.executeUpdate() != 1) return rollbackMutation(con, MutationStatus.NOT_FOUND, productId, currentQty);
                    }
                    con.commit();
                    return result(MutationStatus.UPDATED, productId, currentQty + 1);
                }

                try (PreparedStatement ps = con.prepareStatement(
                        "UPDATE cartitem SET qty = qty - 1 WHERE id = ? AND cart_id = ? AND qty > 1")) {
                    ps.setLong(1, cartItemId);
                    ps.setLong(2, cartId);
                    if (ps.executeUpdate() != 1) return rollbackMutation(con, MutationStatus.NOT_FOUND, productId, currentQty);
                }
                con.commit();
                return result(MutationStatus.UPDATED, productId, currentQty - 1);
            } catch (SQLException ex) {
                rollbackQuietly(con);
                throw ex;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not change cart quantity", ex);
            return result(MutationStatus.DATABASE_ERROR, null, null);
        }
    }

    public MutationResult removeItem(Long userId, Long cartItemId) {
        if (userId == null || cartItemId == null || userId <= 0 || cartItemId <= 0) {
            return result(MutationStatus.NOT_FOUND, null, null);
        }
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                Long cartId = lockExistingCart(con, userId);
                if (cartId == null) return rollbackMutation(con, MutationStatus.NOT_FOUND, null, null);
                long productId;
                int quantity;
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT product_id, qty FROM cartitem WHERE id = ? AND cart_id = ? FOR UPDATE")) {
                    ps.setLong(1, cartItemId);
                    ps.setLong(2, cartId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) return rollbackMutation(con, MutationStatus.NOT_FOUND, null, null);
                        productId = rs.getLong("product_id");
                        quantity = rs.getInt("qty");
                    }
                }
                try (PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM cartitem WHERE id = ? AND cart_id = ?")) {
                    ps.setLong(1, cartItemId);
                    ps.setLong(2, cartId);
                    if (ps.executeUpdate() != 1) return rollbackMutation(con, MutationStatus.NOT_FOUND, null, null);
                }
                con.commit();
                return result(MutationStatus.REMOVED, productId, quantity);
            } catch (SQLException ex) {
                rollbackQuietly(con);
                throw ex;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not remove cart item", ex);
            return result(MutationStatus.DATABASE_ERROR, null, null);
        }
    }

    /** Restores a just-removed line only if the product is still active and in stock. */
    public MutationResult restoreRemovedItem(Long userId, Long productId, int quantity) {
        if (userId == null || productId == null || quantity <= 0) {
            return result(MutationStatus.NOT_FOUND, null, null);
        }
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try {
                long cartId = lockOrCreateCart(con, userId);
                ProductRow product = lockProduct(con, productId);
                if (product == null) return rollbackMutation(con, MutationStatus.NOT_FOUND, productId, null);
                if (!product.active) return rollbackMutation(con, MutationStatus.PRODUCT_INACTIVE, productId, null);
                if (product.stock <= 0) return rollbackMutation(con, MutationStatus.OUT_OF_STOCK, productId, null);

                long itemId = 0;
                int currentQty = 0;
                try (PreparedStatement ps = con.prepareStatement(
                        "SELECT id, qty FROM cartitem WHERE cart_id = ? AND product_id = ? FOR UPDATE")) {
                    ps.setLong(1, cartId);
                    ps.setLong(2, productId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            itemId = rs.getLong("id");
                            currentQty = rs.getInt("qty");
                        }
                    }
                }
                int restoredQty = currentQty + quantity;
                if (restoredQty > product.stock) {
                    return rollbackMutation(con, MutationStatus.STOCK_LIMIT_REACHED, productId, currentQty);
                }
                if (itemId == 0) {
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO cartitem (cart_id, product_id, qty, price) VALUES (?, ?, ?, ?)")) {
                        ps.setLong(1, cartId);
                        ps.setLong(2, productId);
                        ps.setInt(3, quantity);
                        ps.setBigDecimal(4, resolveCurrentPrice(con, userId, productId, quantity, product));
                        ps.executeUpdate();
                    }
                } else {
                    try (PreparedStatement ps = con.prepareStatement(
                            "UPDATE cartitem SET qty = ?, price = ? WHERE id = ? AND cart_id = ?")) {
                        ps.setInt(1, restoredQty);
                        ps.setBigDecimal(2, resolveCurrentPrice(con, userId, productId, restoredQty, product));
                        ps.setLong(3, itemId);
                        ps.setLong(4, cartId);
                        if (ps.executeUpdate() != 1) {
                            return rollbackMutation(con, MutationStatus.DATABASE_ERROR, productId, currentQty);
                        }
                    }
                }
                con.commit();
                return result(MutationStatus.RESTORED, productId, restoredQty);
            } catch (SQLException ex) {
                rollbackQuietly(con);
                throw ex;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not undo cart item removal", ex);
            return result(MutationStatus.DATABASE_ERROR, null, null);
        }
    }

    private long lockOrCreateCart(Connection con, Long userId) throws SQLException {
        String upsert = "INSERT INTO cart (user_id) VALUES (?) ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id)";
        try (PreparedStatement ps = con.prepareStatement(upsert)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
        }
        Long cartId = lockExistingCart(con, userId);
        if (cartId == null) throw new SQLException("Could not create or lock the customer cart");
        return cartId;
    }

    private Long lockExistingCart(Connection con, Long userId) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("SELECT id FROM cart WHERE user_id = ? FOR UPDATE")) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong("id") : null;
            }
        }
    }

    private ProductRow lockProduct(Connection con, Long productId) throws SQLException {
        String sql = "SELECT price, stock, active, is_special_sale, discount_type, discount_value, sale_start_date, sale_end_date FROM product WHERE id = ? FOR UPDATE";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                ProductRow row = new ProductRow();
                row.price = rs.getBigDecimal("price");
                row.stock = rs.getInt("stock");
                row.active = rs.getBoolean("active");
                row.specialSale = rs.getBoolean("is_special_sale");
                row.discountType = rs.getString("discount_type");
                row.discountValue = rs.getBigDecimal("discount_value");
                java.sql.Timestamp start = rs.getTimestamp("sale_start_date");
                java.sql.Timestamp end = rs.getTimestamp("sale_end_date");
                row.saleStartDate = start == null ? null : start.toLocalDateTime();
                row.saleEndDate = end == null ? null : end.toLocalDateTime();
                return row;
            }
        }
    }

    private static final class ProductRow {
        private BigDecimal price;
        private int stock;
        private boolean active;
        private boolean specialSale;
        private String discountType;
        private BigDecimal discountValue;
        private LocalDateTime saleStartDate;
        private LocalDateTime saleEndDate;
    }

    private BigDecimal resolveCurrentPrice(Connection con, Long userId, Long productId, int quantity, ProductRow product) throws SQLException {
        return pricingService.resolvePrice(con, userId, productId, quantity, product.price,
                product.specialSale, product.discountType, product.discountValue,
                product.saleStartDate, product.saleEndDate);
    }

    private AddResult rollbackAdd(Connection con, AddResult result) throws SQLException {
        con.rollback();
        return result;
    }

    private MutationResult rollbackMutation(Connection con, MutationStatus status,
            Long productId, Integer quantity) throws SQLException {
        con.rollback();
        return result(status, productId, quantity);
    }

    private MutationResult result(MutationStatus status, Long productId, Integer quantity) {
        return new MutationResult(status, productId, quantity);
    }

    private void rollbackQuietly(Connection con) {
        try {
            con.rollback();
        } catch (SQLException rollbackError) {
            LOGGER.log(Level.SEVERE, "Could not roll back cart transaction", rollbackError);
        }
    }
}
