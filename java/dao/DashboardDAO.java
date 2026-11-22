package dao;

import java.sql.*;
import java.util.*;
import entity.*;
import util.DBConnection;
import util.AppLogger;

public class DashboardDAO {
    private static final int LOW_STOCK_LEVEL = 5;

    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        try (Connection con = DBConnection.getConnection()) {
            stats.setTotalProducts(count(con, "SELECT COUNT(*) FROM product"));
            stats.setActiveProducts(count(con, "SELECT COUNT(*) FROM product WHERE active = 1"));
            stats.setTotalOrders(count(con, "SELECT COUNT(*) FROM `order`"));
            stats.setPendingOrders(count(con,
                "SELECT COUNT(*) FROM `order` WHERE LOWER(status) IN ('pending','confirmed','processing')"));
            stats.setTotalCustomers(count(con,
                "SELECT COUNT(*) FROM user WHERE LOWER(role) = 'user'"));
            stats.setLowStockCount(count(con,
                "SELECT COUNT(*) FROM product WHERE active = 1 AND stock <= " + LOW_STOCK_LEVEL));
            stats.setRecentOrders(getRecentOrders(con, 6));
            stats.setLowStockProducts(getLowStockProducts(con, 6));
        } catch (SQLException e) {
            AppLogger.error(DashboardDAO.class, "Unable to load dashboard statistics.", e);
        }
        return stats;
    }

    private int count(Connection con, String sql) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private List<Order> getRecentOrders(Connection con, int limit) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.id, o.orderDate, o.status, o.totalAmount, u.id AS user_id, u.name, u.email, u.phone, u.role, u.enable "
                   + "FROM `order` o JOIN user u ON u.id = o.user_id ORDER BY o.orderDate DESC, o.id DESC LIMIT ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) orders.add(mapOrder(rs));
            }
        }
        return orders;
    }

    private List<Product> getLowStockProducts(Connection con, int limit) throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT id, name, description, price, stock, imageUrl, active FROM product "
                   + "WHERE active = 1 AND stock <= ? ORDER BY stock ASC, name ASC LIMIT ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, LOW_STOCK_LEVEL); ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getLong("id")); p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description")); p.setPrice(rs.getDouble("price"));
                    p.setStock(rs.getInt("stock")); p.setImageUrl(rs.getString("imageUrl"));
                    p.setActive(rs.getBoolean("active")); products.add(p);
                }
            }
        }
        return products;
    }

    public AdminSearchResults search(String keyword) {
        AdminSearchResults results = new AdminSearchResults();
        results.setProducts(new ArrayList<>()); results.setOrders(new ArrayList<>()); results.setCustomers(new ArrayList<>());
        if (keyword == null || keyword.trim().isEmpty()) return results;
        String q = keyword.trim(); String like = "%" + q + "%";
        try (Connection con = DBConnection.getConnection()) {
            String productSql = "SELECT p.id,p.name,p.description,p.price,p.stock,p.imageUrl,p.active FROM product p WHERE CAST(p.id AS CHAR) LIKE ? OR p.name LIKE ? OR p.description LIKE ? ORDER BY p.name LIMIT 8";
            try (PreparedStatement ps = con.prepareStatement(productSql)) {
                ps.setString(1, like); ps.setString(2, like); ps.setString(3, like);
                try (ResultSet rs = ps.executeQuery()) { while (rs.next()) { Product p=new Product(); p.setId(rs.getLong("id")); p.setName(rs.getString("name")); p.setDescription(rs.getString("description")); p.setPrice(rs.getDouble("price")); p.setStock(rs.getInt("stock")); p.setImageUrl(rs.getString("imageUrl")); p.setActive(rs.getBoolean("active")); results.getProducts().add(p); } }
            }
            String orderSql = "SELECT o.id,o.orderDate,o.status,o.totalAmount,u.id user_id,u.name,u.email,u.phone,u.role,u.enable FROM `order` o JOIN user u ON u.id=o.user_id WHERE CAST(o.id AS CHAR) LIKE ? OR u.name LIKE ? OR u.email LIKE ? ORDER BY o.orderDate DESC LIMIT 8";
            try (PreparedStatement ps = con.prepareStatement(orderSql)) {
                ps.setString(1, like); ps.setString(2, like); ps.setString(3, like);
                try (ResultSet rs = ps.executeQuery()) { while (rs.next()) results.getOrders().add(mapOrder(rs)); }
            }
            String userSql = "SELECT id,name,email,password,phone,role,enable FROM user WHERE LOWER(role)='user' AND (CAST(id AS CHAR) LIKE ? OR name LIKE ? OR email LIKE ? OR phone LIKE ?) ORDER BY name LIMIT 8";
            try (PreparedStatement ps = con.prepareStatement(userSql)) {
                ps.setString(1, like); ps.setString(2, like); ps.setString(3, like); ps.setString(4, like);
                try (ResultSet rs = ps.executeQuery()) { while (rs.next()) { User u=new User(); u.setId(rs.getLong("id")); u.setName(rs.getString("name")); u.setEmail(rs.getString("email")); u.setPhone(rs.getString("phone")); u.setRole(rs.getString("role")); u.setEnabled(rs.getBoolean("enable")); results.getCustomers().add(u); } }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return results;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order(); o.setId(rs.getLong("id")); Timestamp ts=rs.getTimestamp("orderDate"); if(ts!=null)o.setOrderDate(ts.toLocalDateTime()); o.setStatus(rs.getString("status")); o.setTotalAmount(rs.getDouble("totalAmount"));
        User u = new User(); u.setId(rs.getLong("user_id")); u.setName(rs.getString("name")); u.setEmail(rs.getString("email")); u.setPhone(rs.getString("phone")); u.setRole(rs.getString("role")); u.setEnabled(rs.getBoolean("enable")); o.setUser(u); return o;
    }
}
