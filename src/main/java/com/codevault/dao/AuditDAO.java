package com.codevault.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.codevault.util.DBConnection;

/**
 * Data Access Object for recording security and authentication events in login_audit.
 * Does NOT store passwords, password hashes, session IDs, or tokens.
 */
public class AuditDAO {

    private static final Logger LOGGER = Logger.getLogger(AuditDAO.class.getName());

    public static final String EVENT_USER_REGISTERED = "USER_REGISTERED";
    public static final String EVENT_LOGIN_SUCCESS = "LOGIN_SUCCESS";
    public static final String EVENT_LOGIN_FAILED = "LOGIN_FAILED";
    public static final String EVENT_LOGOUT = "LOGOUT";

    /**
     * Logs an authentication or registration event to login_audit.
     *
     * @param userId     The user ID if known/authenticated; null otherwise.
     * @param eventType  The type of event (e.g. USER_REGISTERED, LOGIN_SUCCESS, LOGIN_FAILED, LOGOUT).
     * @param success    Whether the action succeeded.
     * @param ipAddress  Client IP address (or null).
     * @param userAgent  Client User-Agent header (truncated to 255 chars, or null).
     */
    public void logEvent(Integer userId, String eventType, boolean success, String ipAddress, String userAgent) {
        String sql = "INSERT INTO login_audit (user_id, event_type, success, ip_address, user_agent) VALUES (?, ?, ?, ?, ?)";

        // Truncate User-Agent if exceeds column width
        String sanitizedUserAgent = null;
        if (userAgent != null && !userAgent.isBlank()) {
            sanitizedUserAgent = userAgent.length() > 255 ? userAgent.substring(0, 255) : userAgent;
        }

        // Truncate IP address if exceeds column width
        String sanitizedIp = null;
        if (ipAddress != null && !ipAddress.isBlank()) {
            sanitizedIp = ipAddress.length() > 45 ? ipAddress.substring(0, 45) : ipAddress;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (userId != null && userId > 0) {
                ps.setInt(1, userId);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }

            ps.setString(2, eventType);
            ps.setBoolean(3, success);
            ps.setString(4, sanitizedIp);
            ps.setString(5, sanitizedUserAgent);

            ps.executeUpdate();

        } catch (SQLException e) {
            // Never allow audit logging failure to crash the user application flow
            LOGGER.log(Level.WARNING, "Failed to record audit event: " + eventType, e);
        }
    }
}
