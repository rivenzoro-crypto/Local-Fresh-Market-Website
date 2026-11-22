package dao;

import entity.WholesalePricing;
import util.AppLogger;
import util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WholesalePricingDAO {
    private static final String BASE_SELECT =
            "SELECT wp.id, wp.product_id, p.name AS product_name, p.price AS retail_price, " +
            "wp.min_quantity, wp.wholesale_price, wp.active, wp.created_at, wp.updated_at " +
            "FROM product_wholesale_pricing wp " +
            "JOIN product p ON p.id = wp.product_id ";

    public List<WholesalePricing> getAll() {
        List<WholesalePricing> list = new ArrayList<>();
        String sql = BASE_SELECT + "ORDER BY p.name ASC, wp.min_quantity ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            AppLogger.error(getClass(), "Unable to load wholesale pricing", e);
        }
        return list;
    }

    public boolean create(WholesalePricing pricing) {
        String sql = "INSERT INTO product_wholesale_pricing " +
                "(product_id, min_quantity, wholesale_price, active) VALUES (?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, pricing.getProductId());
            ps.setInt(2, pricing.getMinQuantity());
            ps.setBigDecimal(3, BigDecimal.valueOf(pricing.getWholesalePrice()));
            ps.setBoolean(4, pricing.isActive());
            return ps.executeUpdate() == 1;
        } catch (SQLIntegrityConstraintViolationException e) {
            return false;
        } catch (SQLException e) {
            AppLogger.error(getClass(), "Unable to create wholesale pricing", e);
            return false;
        }
    }

    public boolean update(WholesalePricing pricing) {
        String sql = "UPDATE product_wholesale_pricing SET min_quantity=?, wholesale_price=?, active=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, pricing.getMinQuantity());
            ps.setBigDecimal(2, BigDecimal.valueOf(pricing.getWholesalePrice()));
            ps.setBoolean(3, pricing.isActive());
            ps.setLong(4, pricing.getId());
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            AppLogger.error(getClass(), "Unable to update wholesale pricing", e);
            return false;
        }
    }

    public boolean delete(long id) {
        String sql = "DELETE FROM product_wholesale_pricing WHERE id=?";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            AppLogger.error(getClass(), "Unable to delete wholesale pricing", e);
            return false;
        }
    }


    public WholesalePricing getBestEligibleTier(long productId, int quantity) {
        String sql = BASE_SELECT + " WHERE wp.product_id=? AND wp.active=1 AND wp.min_quantity<=? ORDER BY wp.min_quantity DESC LIMIT 1";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, productId); ps.setInt(2, quantity);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? map(rs) : null; }
        } catch (SQLException e) { AppLogger.error(getClass(), "Unable to find eligible wholesale tier", e); return null; }
    }

    private WholesalePricing map(ResultSet rs) throws SQLException {
        WholesalePricing p = new WholesalePricing();
        p.setId(rs.getLong("id"));
        p.setProductId(rs.getLong("product_id"));
        p.setProductName(rs.getString("product_name"));
        BigDecimal retail = rs.getBigDecimal("retail_price");
        BigDecimal wholesale = rs.getBigDecimal("wholesale_price");
        p.setRetailPrice(retail == null ? 0 : retail.doubleValue());
        p.setMinQuantity(rs.getInt("min_quantity"));
        p.setWholesalePrice(wholesale == null ? 0 : wholesale.doubleValue());
        p.setActive(rs.getBoolean("active"));
        Timestamp created = rs.getTimestamp("created_at");
        Timestamp updated = rs.getTimestamp("updated_at");
        if (created != null) p.setCreatedAt(created.toLocalDateTime());
        if (updated != null) p.setUpdatedAt(updated.toLocalDateTime());
        return p;
    }
}
