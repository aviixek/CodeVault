package com.codevault.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.codevault.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Health check endpoint.
 * Returns minimal JSON status without exposing internal infrastructure details.
 */
@WebServlet("/health")
public class HealthServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(HealthServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        boolean isHealthy = false;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT 1");
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                isHealthy = true;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Health check failed internal database connectivity test.", e);
        }

        PrintWriter out = response.getWriter();
        if (isHealthy) {
            response.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"status\":\"UP\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            out.print("{\"status\":\"DOWN\"}");
        }
        out.flush();
    }
}
