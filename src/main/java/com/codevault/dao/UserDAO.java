package com.codevault.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import at.favre.lib.crypto.bcrypt.BCrypt;

import com.codevault.model.User;
import com.codevault.util.DBConnection;

public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    // BCrypt cost factor: 12 is a good balance of security vs. performance
    private static final int BCRYPT_COST = 12;

    /**
     * Registers a new user with a BCrypt-hashed password.
     * The plaintext password is hashed before storage and never logged.
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users(username, email, password) VALUES(?, ?, ?)";

        // Hash the password before storing
        String hashedPassword = BCrypt.withDefaults()
                .hashToString(BCRYPT_COST, user.getPassword().toCharArray());

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashedPassword);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            // Check for duplicate key violations
            if (e.getErrorCode() == 1062) {
                LOGGER.log(Level.INFO, "Duplicate username or email during registration.");
            } else {
                LOGGER.log(Level.SEVERE, "Error registering user.", e);
            }
            return false;
        }
    }

    /**
     * Validates login credentials. Fetches user by username or email,
     * then verifies the password against the stored BCrypt hash.
     *
     * If the stored password is plaintext (legacy migration), it will
     * be automatically upgraded to BCrypt on successful login.
     */
    public User validateUser(String login, String password) {
        String sql = "SELECT id, username, email, password FROM users WHERE username=? OR email=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, login);
            ps.setString(2, login);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    boolean authenticated = false;
                    boolean needsUpgrade = false;

                    // Check if the stored password is a BCrypt hash ($2a$, $2b$, $2y$)
                    if (storedPassword != null && storedPassword.startsWith("$2")) {
                        // Verify against BCrypt hash
                        BCrypt.Result result = BCrypt.verifyer()
                                .verify(password.toCharArray(), storedPassword);
                        authenticated = result.verified;
                    } else {
                        // Legacy plaintext password — verify directly
                        authenticated = storedPassword != null && storedPassword.equals(password);
                        if (authenticated) {
                            needsUpgrade = true;
                        }
                    }

                    if (authenticated) {
                        User user = new User();
                        user.setId(rs.getInt("id"));
                        user.setUsername(rs.getString("username"));
                        user.setEmail(rs.getString("email"));
                        // Never set password on the returned User object

                        // Upgrade plaintext password to BCrypt
                        if (needsUpgrade) {
                            upgradePassword(user.getId(), password);
                        }

                        return user;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error validating user.", e);
        }

        return null;
    }

    /**
     * Upgrades a legacy plaintext password to BCrypt hash.
     * Called automatically on successful login with a plaintext password.
     */
    private void upgradePassword(int userId, String plaintextPassword) {
        String sql = "UPDATE users SET password=? WHERE id=?";
        String hashedPassword = BCrypt.withDefaults()
                .hashToString(BCRYPT_COST, plaintextPassword.toCharArray());

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            ps.executeUpdate();

            LOGGER.info("Password upgraded to BCrypt for user ID: " + userId);

        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Failed to upgrade password hash for user ID: " + userId, e);
        }
    }

    /**
     * Checks if a username already exists.
     */
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking username existence.", e);
        }
        return false;
    }

    /**
     * Checks if an email already exists.
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking email existence.", e);
        }
        return false;
    }
}
