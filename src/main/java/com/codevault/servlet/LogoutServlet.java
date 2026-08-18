package com.codevault.servlet;

import java.io.IOException;
import java.util.logging.Logger;

import com.codevault.dao.AuditDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Logout servlet — POST-only endpoint that records the LOGOUT audit event,
 * invalidates the user's session, and redirects to login.
 * GET requests are rejected with HTTP 405 (Method Not Allowed) without invalidating session.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LogoutServlet.class.getName());

    private final AuditDAO auditDAO;

    public LogoutServlet() {
        this(new AuditDAO());
    }

    public LogoutServlet(AuditDAO auditDAO) {
        this.auditDAO = auditDAO != null ? auditDAO : new AuditDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String clientIp = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");

        if (session != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            String username = (String) session.getAttribute("username");

            // Record LOGOUT audit event for authenticated user
            if (userId != null) {
                auditDAO.logEvent(userId, AuditDAO.EVENT_LOGOUT, true, clientIp, userAgent);
            }

            session.invalidate();

            if (username != null) {
                LOGGER.info("User logged out: " + username);
            }
        }

        // Prevent caching of post-logout responses
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        // GET logout is explicitly rejected — does NOT invalidate session
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Method Not Allowed");
    }
}
