package util;

import java.util.logging.Level;
import java.util.logging.Logger;

/** Centralized application logging utility. */
public final class AppLogger {

    private AppLogger() {
        // Utility class.
    }

    private static Logger logger(Class<?> source) {
        return Logger.getLogger(source == null ? AppLogger.class.getName() : source.getName());
    }

    public static void info(Class<?> source, String message) {
        logger(source).info(message);
    }

    public static void warning(Class<?> source, String message) {
        logger(source).warning(message);
    }

    public static void error(Class<?> source, String message) {
        logger(source).severe(message);
    }

    public static void error(Class<?> source, String message, Throwable cause) {
        logger(source).log(Level.SEVERE, message, cause);
    }

    public static void debug(Class<?> source, String message) {
        logger(source).fine(message);
    }
}
