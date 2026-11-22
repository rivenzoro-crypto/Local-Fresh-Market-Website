package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import entity.Order;
import entity.User;
import util.AppLogger;
import util.DBConnection;

/** JDBC data access for customer orders. */
public class OrderDAO {

    private static final String ORDER_SELECT =
            "SELECT o.id, o.user_id, o.orderDate, o.status, o.totalAmount, o.order_type, "
          + "o.shipping_city, o.shipping_township, o.shipping_street, o.shipping_description, "
          + "u.name AS customer_name, u.email AS customer_email, "
          + "u.phone AS customer_phone, u.role AS customer_role, "
          + "u.enable AS customer_enabled "
          + "FROM `order` o LEFT JOIN `user` u ON u.id = o.user_id ";

    /**
     * @deprecated Use CheckoutDAO.checkout() for customer checkout so order,
     * items, stock changes and cart clearing remain in one transaction.
     */
    @Deprecated
    public Long createOrder(Order order) {
        if (order == null || order.getUser() == null || order.getUser().getId() == null) {
            return null;
        }

        String sql = "INSERT INTO `order` (user_id, orderDate, status, totalAmount) VALUES (?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            statement.setLong(1, order.getUser().getId());
            LocalDateTime date = order.getOrderDate() == null ? LocalDateTime.now() : order.getOrderDate();
            statement.setTimestamp(2, Timestamp.valueOf(date));
            statement.setString(3, order.getStatus());
            statement.setDouble(4, order.getTotalAmount() == null ? 0.0 : order.getTotalAmount());

            if (statement.executeUpdate() == 0) return null;
            try (ResultSet keys = statement.getGeneratedKeys()) {
                return keys.next() ? keys.getLong(1) : null;
            }
        } catch (SQLException ex) {
            AppLogger.error(OrderDAO.class, "Unable to create order.", ex);
            return null;
        }
    }

    public List<Order> getAllOrders() {
        return searchOrders(null, null, null, null, null, null, null);
    }

    /** Returns orders matching the supplied optional admin filters. */
    public List<Order> searchOrders(String keyword, String status,
                                    LocalDate dateFrom, LocalDate dateTo,
                                    BigDecimal minAmount, BigDecimal maxAmount) {
        return searchOrders(keyword, status, null, dateFrom, dateTo, minAmount, maxAmount);
    }

    /** Search orders with optional RETAIL/WHOLESALE classification. */
    public List<Order> searchOrders(String keyword, String status, String orderType,
                                    LocalDate dateFrom, LocalDate dateTo,
                                    BigDecimal minAmount, BigDecimal maxAmount) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder(ORDER_SELECT).append(" WHERE 1 = 1 ");
        List<Object> parameters = new ArrayList<>();

        if (hasText(keyword)) {
            String term = keyword.trim();
            sql.append(" AND (CAST(o.id AS CHAR) LIKE ? OR LOWER(COALESCE(u.name, '')) LIKE ?")
               .append(" OR LOWER(COALESCE(u.email, '')) LIKE ? OR COALESCE(u.phone, '') LIKE ?) ");
            String like = "%" + term.toLowerCase(java.util.Locale.ROOT) + "%";
            parameters.add(like);
            parameters.add(like);
            parameters.add(like);
            parameters.add("%" + term + "%");
        }

        if (hasText(status) && !"all".equalsIgnoreCase(status)) {
            sql.append(" AND LOWER(o.status) = ? ");
            parameters.add(status.trim().toLowerCase(java.util.Locale.ROOT));
        }
        if (hasText(orderType) && !"all".equalsIgnoreCase(orderType)) {
            sql.append(" AND UPPER(o.order_type) = ? ");
            parameters.add(orderType.trim().toUpperCase(java.util.Locale.ROOT));
        }
        if (dateFrom != null) {
            sql.append(" AND o.orderDate >= ? ");
            parameters.add(Timestamp.valueOf(dateFrom.atStartOfDay()));
        }
        if (dateTo != null) {
            sql.append(" AND o.orderDate < ? ");
            parameters.add(Timestamp.valueOf(dateTo.plusDays(1).atStartOfDay()));
        }
        if (minAmount != null) {
            sql.append(" AND o.totalAmount >= ? ");
            parameters.add(minAmount);
        }
        if (maxAmount != null) {
            sql.append(" AND o.totalAmount <= ? ");
            parameters.add(maxAmount);
        }
        sql.append(" ORDER BY o.orderDate DESC, o.id DESC");

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) orders.add(mapOrder(rs));
            }
        } catch (SQLException ex) {
            AppLogger.error(OrderDAO.class, "Unable to search orders.", ex);
        }
        return orders;
    }

    public Order getOrderById(Long id) {
        if (id == null) return null;
        String sql = ORDER_SELECT + " WHERE o.id = ? LIMIT 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() ? mapOrder(rs) : null;
            }
        } catch (SQLException ex) {
            AppLogger.error(OrderDAO.class, "Unable to retrieve order ID " + id + ".", ex);
            return null;
        }
    }

    public List<Order> getAllOrdersByUserId(Long userId) {
        List<Order> orders = new ArrayList<>();
        if (userId == null) return orders;
        String sql = ORDER_SELECT + " WHERE o.user_id = ? ORDER BY o.orderDate DESC, o.id DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) orders.add(mapOrder(rs));
            }
        } catch (SQLException ex) {
            AppLogger.error(OrderDAO.class, "Unable to retrieve orders for user ID " + userId + ".", ex);
        }
        return orders;
    }

    public Boolean updateOrder(Order order) {
        if (order == null || order.getId() == null || order.getUser() == null || order.getUser().getId() == null) {
            return false;
        }
        String sql = "UPDATE `order` SET user_id = ?, orderDate = ?, status = ?, totalAmount = ? WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, order.getUser().getId());
            statement.setTimestamp(2, order.getOrderDate() == null ? null : Timestamp.valueOf(order.getOrderDate()));
            statement.setString(3, order.getStatus());
            statement.setDouble(4, order.getTotalAmount() == null ? 0.0 : order.getTotalAmount());
            statement.setLong(5, order.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            AppLogger.error(OrderDAO.class, "Unable to update order ID " + order.getId() + ".", ex);
            return false;
        }
    }

    public Boolean deleteOrder(Long id) {
        if (id == null) return false;
        String sql = "DELETE FROM `order` WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            AppLogger.error(OrderDAO.class, "Unable to delete order ID " + id + ".", ex);
            return false;
        }
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getLong("id"));

        long userId = rs.getLong("user_id");
        if (!rs.wasNull()) {
            User user = new User();
            user.setId(userId);
            user.setName(rs.getString("customer_name"));
            user.setEmail(rs.getString("customer_email"));
            user.setPhone(rs.getString("customer_phone"));
            user.setRole(rs.getString("customer_role"));
            user.setEnabled(rs.getBoolean("customer_enabled"));
            order.setUser(user);
        }

        Timestamp timestamp = rs.getTimestamp("orderDate");
        if (timestamp != null) order.setOrderDate(timestamp.toLocalDateTime());
        order.setStatus(rs.getString("status"));
        order.setOrderType(rs.getString("order_type"));
        order.setShippingCity(rs.getString("shipping_city"));
        order.setShippingTownship(rs.getString("shipping_township"));
        order.setShippingStreet(rs.getString("shipping_street"));
        order.setShippingDescription(rs.getString("shipping_description"));
        order.setTotalAmount(rs.getDouble("totalAmount"));
        return order;
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
