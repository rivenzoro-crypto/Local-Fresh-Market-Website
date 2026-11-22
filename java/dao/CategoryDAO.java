package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import entity.Category;
import util.DBConnection;

public class CategoryDAO {
    private static final Logger LOGGER = Logger.getLogger(CategoryDAO.class.getName());

    public List<Category> getActiveCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT id, name, slug, active FROM product_category WHERE active = 1 ORDER BY name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(map(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not load product categories", ex);
        }
        return categories;
    }

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT id, name, slug, active FROM product_category ORDER BY name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(map(rs));
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not load all product categories", ex);
        }
        return categories;
    }

    public Category getActiveCategoryBySlug(String slug) {
        if (slug == null || slug.isBlank()) return null;
        String sql = "SELECT id, name, slug, active FROM product_category WHERE slug = ? AND active = 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, slug.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not find product category", ex);
            return null;
        }
    }

    public Category getActiveCategoryById(Long id) {
        if (id == null || id <= 0) return null;
        String sql = "SELECT id, name, slug, active FROM product_category WHERE id = ? AND active = 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not find product category by ID", ex);
            return null;
        }
    }

    private Category map(ResultSet rs) throws SQLException {
        return new Category(rs.getLong("id"), rs.getString("name"),
                rs.getString("slug"), rs.getBoolean("active"));
    }
}
