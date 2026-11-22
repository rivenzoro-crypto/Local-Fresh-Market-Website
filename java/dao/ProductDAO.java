package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import entity.Product;
import util.DBConnection;

public class ProductDAO {
    private static final Logger LOGGER = Logger.getLogger(ProductDAO.class.getName());
    private static final String SELECT_WITH_CATEGORY =
            "SELECT p.id, p.name, p.description, p.price, p.stock, p.imageUrl, p.active, "
            + "p.category_id, p.is_special_sale, p.discount_type, p.discount_value, "
            + "p.sale_start_date, p.sale_end_date, "
            + "c.name AS category_name, c.slug AS category_slug "
            + "FROM product p LEFT JOIN product_category c ON c.id = p.category_id ";
    
    public boolean createProduct(Product product) {
//        String sql = "INSERT INTO product (name, description, price, stock, imageUrl, active, category_id) "
//                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
    	String sql = "INSERT INTO product "
    	        + "(name, description, price, stock, imageUrl, active, category_id, "
    	        + "is_special_sale, discount_type, discount_value, sale_start_date, sale_end_date) "
    	        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    	
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            bindProduct(ps, product, false);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not create product", ex);
            return false;
        }
    }

    public List<Product> getAllProducts() {
        return queryProducts(SELECT_WITH_CATEGORY + "ORDER BY p.id DESC");
    }

    public List<Product> getAllActiveProducts() {
        List<Product> products = getActiveProducts(null, null);
        return products == null ? new ArrayList<>() : products;
    }

    /** Returns null on database failure so the controller can show a catalog error. */
    public List<Product> getActiveProducts(String categorySlug, String searchText) {
        StringBuilder sql = new StringBuilder(SELECT_WITH_CATEGORY).append("WHERE p.active = 1 ");
        List<String> parameters = new ArrayList<>();
        if (categorySlug != null && !categorySlug.isBlank()) {
            sql.append("AND c.slug = ? ");
            parameters.add(categorySlug);
        }
        if (searchText != null && !searchText.isBlank()) {
            sql.append("AND (p.name LIKE ? OR p.description LIKE ? OR c.name LIKE ?) ");
            String like = "%" + searchText.trim() + "%";
            parameters.add(like);
            parameters.add(like);
            parameters.add(like);
        }
        sql.append("ORDER BY p.name ASC");
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setString(i + 1, parameters.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                List<Product> products = new ArrayList<>();
                while (rs.next()) products.add(mapProduct(rs));
                return products;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not search active products", ex);
            return null;
        }
    }

    public Product getProductById(Long id) {
        if (id == null || id <= 0) return null;
        return querySingle(SELECT_WITH_CATEGORY + "WHERE p.id = ?", id);
    }

    public Product getActiveProductById(Long id) {
        if (id == null || id <= 0) return null;
        return querySingle(SELECT_WITH_CATEGORY + "WHERE p.id = ? AND p.active = 1", id);
    }

    public boolean updateProduct(Product product) {
//        String sql = "UPDATE product SET name = ?, description = ?, price = ?, stock = ?, "
//                + "imageUrl = ?, active = ?, category_id = ? WHERE id = ?";
    	String sql = "UPDATE product SET "
    	        + "name = ?, "
    	        + "description = ?, "
    	        + "price = ?, "
    	        + "stock = ?, "
    	        + "imageUrl = ?, "
    	        + "active = ?, "
    	        + "category_id = ?, "
    	        + "is_special_sale = ?, "
    	        + "discount_type = ?, "
    	        + "discount_value = ?, "
    	        + "sale_start_date = ?, "
    	        + "sale_end_date = ? "
    	        + "WHERE id = ?";
    	
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            bindProduct(ps, product, true);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not update product", ex);
            return false;
        }
    }

    public boolean softDelete(Long id) {
        String sql = "UPDATE product SET active = 0 WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not deactivate product", ex);
            return false;
        }
    }

    private List<Product> queryProducts(String sql) {
        List<Product> products = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) products.add(mapProduct(rs));
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not load products", ex);
        }
        return products;
    }

    private Product querySingle(String sql, Long id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapProduct(rs) : null;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not load product", ex);
            return null;
        }
    }
    
    public List<Product> getActiveSpecialSaleProducts() {
        List<Product> products = new ArrayList<>();
        String sql = SELECT_WITH_CATEGORY + 
                     "WHERE p.active = 1 AND p.is_special_sale = 1 " +
                     "AND (p.sale_start_date IS NULL OR p.sale_start_date <= ?) " +
                     "AND (p.sale_end_date IS NULL OR p.sale_end_date >= ?) " +
                     "ORDER BY p.id DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            java.sql.Timestamp now = java.sql.Timestamp.valueOf(java.time.LocalDateTime.now());
            ps.setTimestamp(1, now);
            ps.setTimestamp(2, now);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Could not load active special sale products", ex);
        }
        return products;
    }

    private Product mapProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getLong("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        java.math.BigDecimal price = rs.getBigDecimal("price");
        product.setPrice(price == null ? 0.0 : price.doubleValue());
        product.setStock(rs.getInt("stock"));
        product.setImageUrl(rs.getString("imageUrl"));
        product.setActive(rs.getBoolean("active"));
        long categoryId = rs.getLong("category_id");
        product.setCategoryId(rs.wasNull() ? null : categoryId);
        product.setCategoryName(rs.getString("category_name"));
        product.setCategorySlug(rs.getString("category_slug"));
        
        product.setSpecialSale(rs.getBoolean("is_special_sale"));

        if (rs.wasNull()) {
            product.setSpecialSale(false);
        }

        product.setDiscountType(rs.getString("discount_type"));

        java.math.BigDecimal discountValue = rs.getBigDecimal("discount_value");

        if (discountValue != null) {
            product.setDiscountValue(discountValue.doubleValue());
        }

        java.sql.Timestamp saleStart = rs.getTimestamp("sale_start_date");

        if (saleStart != null) {
            product.setSaleStartDate(saleStart.toLocalDateTime());
        }

        java.sql.Timestamp saleEnd = rs.getTimestamp("sale_end_date");

        if (saleEnd != null) {
            product.setSaleEndDate(saleEnd.toLocalDateTime());
        }
        return product;
    }

//    private void bindProduct(PreparedStatement ps, Product product, boolean includeId) throws SQLException {
//        ps.setString(1, product.getName());
//        ps.setString(2, product.getDescription());
//        ps.setBigDecimal(3, java.math.BigDecimal.valueOf(product.getPrice()));
//        ps.setInt(4, product.getStock());
//        ps.setString(5, product.getImageUrl());
//        ps.setBoolean(6, product.isActive());
//        if (product.getCategoryId() == null) ps.setNull(7, java.sql.Types.BIGINT);
//        else ps.setLong(7, product.getCategoryId());
//        if (includeId) ps.setLong(8, product.getId());
//    }
    private void bindProduct(PreparedStatement ps, Product product, boolean includeId)
            throws SQLException {

        ps.setString(1, product.getName());
        ps.setString(2, product.getDescription());

        ps.setBigDecimal(3,
                java.math.BigDecimal.valueOf(product.getPrice()));

        ps.setInt(4, product.getStock());

        ps.setString(5, product.getImageUrl());

        ps.setBoolean(6, product.isActive());

        if (product.getCategoryId() == null) {
            ps.setNull(7, java.sql.Types.BIGINT);
        } else {
            ps.setLong(7, product.getCategoryId());
        }

        // Special Sale
        ps.setBoolean(8, Boolean.TRUE.equals(product.getSpecialSale()));

        if (product.getDiscountType() == null ||
                product.getDiscountType().isBlank()) {

            ps.setNull(9, java.sql.Types.VARCHAR);

        } else {

            ps.setString(9, product.getDiscountType());
        }

        if (product.getDiscountValue() == null) {

            ps.setNull(10, java.sql.Types.DECIMAL);

        } else {

            ps.setBigDecimal(10,
                    java.math.BigDecimal.valueOf(product.getDiscountValue()));
        }

        if (product.getSaleStartDate() == null) {

            ps.setNull(11, java.sql.Types.TIMESTAMP);

        } else {

            ps.setTimestamp(11,
                    java.sql.Timestamp.valueOf(product.getSaleStartDate()));
        }

        if (product.getSaleEndDate() == null) {

            ps.setNull(12, java.sql.Types.TIMESTAMP);

        } else {

            ps.setTimestamp(12,
                    java.sql.Timestamp.valueOf(product.getSaleEndDate()));
        }

        if (includeId) {

            ps.setLong(13, product.getId());
        }
    }
}
