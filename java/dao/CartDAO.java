package dao;

import entity.Cart;
import entity.User;
import util.AppLogger;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Data access methods for shopping carts. */
public class CartDAO {

    private static final String CART_COLUMNS = "c.id, c.user_id";
    private static final String USER_COLUMNS =
            "u.id AS u_id, u.name AS u_name, u.email AS u_email, "
            + "u.phone AS u_phone, u.role AS u_role, u.enable AS u_enable";

    public Boolean createCart(Cart cart) {
        if (cart == null || cart.getUser() == null || cart.getUser().getId() == null) {
            return false;
        }

        String sql = "INSERT INTO cart (user_id) VALUES (?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, cart.getUser().getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            AppLogger.error(CartDAO.class, "Unable to create cart.", ex);
            return false;
        }
    }

    public List<Cart> getAllCarts() {
        List<Cart> carts = new ArrayList<>();
        String sql = "SELECT " + CART_COLUMNS + ", " + USER_COLUMNS
                + " FROM cart c LEFT JOIN user u ON u.id = c.user_id ORDER BY c.id";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                carts.add(mapCart(resultSet));
            }
        } catch (SQLException ex) {
            AppLogger.error(CartDAO.class, "Unable to retrieve carts.", ex);
        }
        return carts;
    }

    public Cart getCartById(Long id) {
        if (id == null) return null;
        String sql = "SELECT " + CART_COLUMNS + ", " + USER_COLUMNS
                + " FROM cart c LEFT JOIN user u ON u.id = c.user_id WHERE c.id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? mapCart(resultSet) : null;
            }
        } catch (SQLException ex) {
            AppLogger.error(CartDAO.class, "Unable to retrieve cart by ID: " + id, ex);
            return null;
        }
    }

    /** One user should have one cart; the database should enforce UNIQUE(cart.user_id). */
    public Cart getCartByUserId(Long userId) {
        if (userId == null) return null;
        String sql = "SELECT " + CART_COLUMNS + ", " + USER_COLUMNS
                + " FROM cart c LEFT JOIN user u ON u.id = c.user_id WHERE c.user_id = ? LIMIT 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? mapCart(resultSet) : null;
            }
        } catch (SQLException ex) {
            AppLogger.error(CartDAO.class, "Unable to retrieve cart for user ID: " + userId, ex);
            return null;
        }
    }

    public Boolean deleteCart(Long id) {
        if (id == null) return false;
        String sql = "DELETE FROM cart WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            AppLogger.error(CartDAO.class, "Unable to delete cart ID: " + id, ex);
            return false;
        }
    }

    private Cart mapCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setId(rs.getLong("id"));

        long userId = rs.getLong("u_id");
        if (!rs.wasNull()) {
            User user = new User();
            user.setId(userId);
            user.setName(rs.getString("u_name"));
            user.setEmail(rs.getString("u_email"));
            user.setPhone(rs.getString("u_phone"));
            user.setRole(rs.getString("u_role"));
            user.setEnabled(rs.getBoolean("u_enable"));
            // Never load a password/hash into nested cart/session objects.
            cart.setUser(user);
        }
        return cart;
    }
}
