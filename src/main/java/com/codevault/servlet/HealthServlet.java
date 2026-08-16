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

        boolean dbHealthy = false;
        String dbError = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT 1");
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                dbHealthy = true;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Health check: Database ping failed", e);
            dbError = e.getMessage();
        }

        PrintWriter out = response.getWriter();
        if (dbHealthy) {
            response.setStatus(HttpServletResponse.SC_OK);
            out.print("{\"status\":\"UP\",\"database\":\"HEALTHY\"}");
        } else {
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            String safeError = (dbError != null) ? dbError.replace("\"", "\\\"") : "Connection failed";
            out.print("{\"status\":\"DEGRADED\",\"database\":\"DOWN\",\"error\":\"" + safeError + "\"}");
        }
        out.flush();
    }
}
