package com.codevault.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Provides database connections via HikariCP connection pool.
 * Configuration is read from environment variables.
 * Fails fast if required credentials (DB_USER, DB_PASSWORD) are missing.
 */
public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    private static volatile HikariDataSource dataSource;

    private DBConnection() {
        // Prevent instantiation
    }

    private static void initDataSource() {
        if (dataSource != null) {
            return;
        }

        synchronized (DBConnection.class) {
            if (dataSource != null) {
                return;
            }

            String host = getEnvOrDefault("DB_HOST", "localhost");
            String port = getEnvOrDefault("DB_PORT", "3306");
            String dbName = getEnvOrDefault("DB_NAME", "codevault");
            String user = System.getenv("DB_USER");
            String password = System.getenv("DB_PASSWORD");

            // Fail fast: Required credentials must be explicitly configured
            if (user == null || user.isBlank()) {
                throw new IllegalStateException(
                        "Database configuration error: DB_USER environment variable must be set.");
            }
            if (password == null || password.isEmpty()) {
                throw new IllegalStateException(
                        "Database configuration error: DB_PASSWORD environment variable must be set and cannot be empty.");
            }

            String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName
                    + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(url);
            config.setUsername(user.trim());
            config.setPassword(password);
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

            // Pool tuning
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setIdleTimeout(300_000);       // 5 minutes
            config.setConnectionTimeout(10_000);  // 10 seconds
            config.setMaxLifetime(600_000);       // 10 minutes
            config.setLeakDetectionThreshold(60_000); // 1 minute

            // Connection validation
            config.setConnectionTestQuery("SELECT 1");

            try {
                dataSource = new HikariDataSource(config);
                LOGGER.info("HikariCP connection pool initialized successfully.");
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Failed to initialize HikariCP connection pool.", e);
                throw new RuntimeException("Database connection pool initialization failed.", e);
            }
        }
    }

    /**
     * Gets a connection from the pool. Caller MUST close the connection
     * (preferably via try-with-resources) to return it to the pool.
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            initDataSource();
        }
        return dataSource.getConnection();
    }

    /**
     * Shuts down the connection pool. Called during application shutdown.
     */
    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            LOGGER.info("HikariCP connection pool shut down.");
        }
    }

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.isBlank()) ? value.trim() : defaultValue;
    }
}