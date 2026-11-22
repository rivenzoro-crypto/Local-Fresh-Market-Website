package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Provides JDBC connections to the application's MySQL database. */
public final class DBConnection {

    // Keep the existing local development configuration unchanged.
    private static final String URL = "jdbc:mysql://localhost:3306/fmp";
    private static final String USER = "root";
    private static final String PASSWORD = "12345";
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    static {
        try {
            Class.forName(DRIVER_CLASS);
            AppLogger.info(DBConnection.class, "MySQL JDBC driver loaded successfully.");
        } catch (ClassNotFoundException ex) {
            AppLogger.error(DBConnection.class,
                    "MySQL Connector/J is missing from WEB-INF/lib.", ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    private DBConnection() {
        // Utility class.
    }

    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException ex) {
            AppLogger.error(DBConnection.class,
                    "Could not connect to database 'fmp'. Check MySQL service and local credentials.", ex);
            throw ex;
        }
    }
}
