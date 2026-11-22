package util;

import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

/**
 * Releases MySQL Connector/J resources when this web application is stopped
 * or reloaded by Tomcat. This prevents the driver's cleanup thread and
 * webapp-loaded JDBC driver from being retained by the old webapp classloader.
 */
public class DatabaseCleanupListener implements ServletContextListener {

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        // Stop Connector/J's background cleanup thread first.
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
        } catch (Exception e) {
            event.getServletContext().log(
                    "Could not stop MySQL abandoned-connection cleanup thread", e);
        }

        // Deregister only drivers loaded by this web application's classloader.
        ClassLoader webAppClassLoader = getClass().getClassLoader();
        List<Driver> driversToDeregister = new ArrayList<>();
        Enumeration<Driver> drivers = DriverManager.getDrivers();

        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            if (driver.getClass().getClassLoader() == webAppClassLoader) {
                driversToDeregister.add(driver);
            }
        }

        for (Driver driver : driversToDeregister) {
            try {
                DriverManager.deregisterDriver(driver);
            } catch (SQLException e) {
                event.getServletContext().log(
                        "Could not deregister JDBC driver " + driver, e);
            }
        }
    }
}
