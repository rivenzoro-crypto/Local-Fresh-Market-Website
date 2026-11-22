package dao;

import entity.User;
import util.AppLogger;
import util.DBConnection;
import util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/** Data access methods for users. Passwords are stored as PBKDF2 hashes. */
public class UserDAO {

    private static final String USER_COLUMNS =
            "id, name, email, phone, role, enable";
    private static final String AUTH_COLUMNS = USER_COLUMNS + ", password";

    public Boolean createUser(User user) {
        if (user == null || isBlank(user.getName()) || isBlank(user.getEmail())
                || isBlank(user.getPassword()) || isBlank(user.getRole())) {
            return false;
        }

        String sql = "INSERT INTO user (name, email, password, phone, role, enable) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getName().trim());
            statement.setString(2, user.getEmail().trim());
            statement.setString(3, PasswordUtil.hash(user.getPassword()));
            statement.setString(4, user.getPhone());
            statement.setString(5, user.getRole());
            statement.setBoolean(6, Boolean.TRUE.equals(user.getEnabled()));
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            AppLogger.error(UserDAO.class, "Unable to create user. Check whether the email already exists.", ex);
            return false;
        } catch (IllegalStateException ex) {
            AppLogger.error(UserDAO.class, "Unable to hash the new user's password.", ex);
            return false;
        }
    }

    /** Returns user profile data only; password hashes are deliberately excluded. */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT " + USER_COLUMNS + " FROM user ORDER BY id DESC";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) users.add(mapUser(rs, false));
        } catch (SQLException ex) {
            AppLogger.error(UserDAO.class, "Unable to retrieve users.", ex);
        }
        return users;
    }

    /** Returns profile data only; password hashes are not needed by callers of this method. */
    public User getUserById(Long id) {
        if (id == null) return null;
        String sql = "SELECT " + USER_COLUMNS + " FROM user WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() ? mapUser(rs, false) : null;
            }
        } catch (SQLException ex) {
            AppLogger.error(UserDAO.class, "Unable to retrieve user ID: " + id, ex);
            return null;
        }
    }

    /** Updates profile fields without overwriting the password. */
    public Boolean updateUser(User user) {
        if (user == null || user.getId() == null) return false;
        String sql = "UPDATE user SET name = ?, email = ?, phone = ?, role = ?, enable = ? WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPhone());
            statement.setString(4, user.getRole());
            statement.setBoolean(5, Boolean.TRUE.equals(user.getEnabled()));
            statement.setLong(6, user.getId());
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            AppLogger.error(UserDAO.class, "Unable to update user ID: " + user.getId(), ex);
            return false;
        }
    }

    public Boolean deactivateUser(Long userId) {
        return setUserEnabled(userId, false);
    }

    public Boolean activateUser(Long userId) {
        return setUserEnabled(userId, true);
    }

    private Boolean setUserEnabled(Long userId, boolean enabled) {
        if (userId == null) return false;
        String sql = "UPDATE user SET enable = ? WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setBoolean(1, enabled);
            statement.setLong(2, userId);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            AppLogger.error(UserDAO.class, "Unable to change enabled status for user ID: " + userId, ex);
            return false;
        }
    }

    public Boolean deleteUser(Long id) {
        if (id == null) return false;
        String sql = "DELETE FROM user WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, id);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            AppLogger.error(UserDAO.class, "Unable to delete user ID: " + id, ex);
            return false;
        }
    }

    /** Authentication lookup; this is the only general lookup that reads password. */
    public User getUserByEmail(String email) {
        if (isBlank(email)) return null;
        String sql = "SELECT " + AUTH_COLUMNS + " FROM user WHERE email = ? LIMIT 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email.trim());
            try (ResultSet rs = statement.executeQuery()) {
                return rs.next() ? mapUser(rs, true) : null;
            }
        } catch (SQLException ex) {
            AppLogger.error(UserDAO.class, "Unable to find user by email.", ex);
            return null;
        }
    }

    /** Verifies a password and transparently upgrades a legacy plaintext record after successful login. */
    public boolean verifyPassword(User user, String rawPassword) {
        if (user == null || user.getId() == null || isBlank(rawPassword)
                || !PasswordUtil.verify(rawPassword, user.getPassword())) {
            return false;
        }

        if (PasswordUtil.needsRehash(user.getPassword())) {
            String newHash = PasswordUtil.hash(rawPassword);
            String sql = "UPDATE user SET password = ? WHERE id = ? AND password = ?";
            try (Connection connection = DBConnection.getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, newHash);
                statement.setLong(2, user.getId());
                statement.setString(3, user.getPassword());
                statement.executeUpdate();
                user.setPassword(newHash);
            } catch (SQLException ex) {
                // Login can still succeed; next successful login can retry the upgrade.
                AppLogger.error(UserDAO.class, "Password verified, but legacy password upgrade failed.", ex);
            }
        }
        return true;
    }

    private User mapUser(ResultSet rs, boolean includePassword) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        if (includePassword) user.setPassword(rs.getString("password"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getString("role"));
        user.setEnabled(rs.getBoolean("enable"));
        return user;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
