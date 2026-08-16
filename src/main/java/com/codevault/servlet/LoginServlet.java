package com.codevault.servlet;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

import com.codevault.dao.UserDAO;
import com.codevault.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String login = request.getParameter("username");
        String password = request.getParameter("password");

        // Basic input validation — do NOT log the password
        if (login == null || login.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        User user = dao.validateUser(login.trim(), password);

        if (user != null) {
            // --- Session fixation protection ---
            // 1. Save any existing session attributes we want to keep (e.g., CSRF token)
            HttpSession oldSession = request.getSession(false);
            Map<String, Object> preserved = new HashMap<>();
            if (oldSession != null) {
                // Preserve CSRF token across session regeneration
                Object csrfToken = oldSession.getAttribute("csrf_token");
                if (csrfToken != null) {
                    preserved.put("csrf_token", csrfToken);
                }
                // 2. Invalidate the old (unauthenticated) session
                oldSession.invalidate();
            }

            // 3. Create a new authenticated session
            HttpSession newSession = request.getSession(true);

            // 4. Restore preserved attributes
            for (Map.Entry<String, Object> entry : preserved.entrySet()) {
                newSession.setAttribute(entry.getKey(), entry.getValue());
            }

            // 5. Set authenticated identity (minimum required)
            newSession.setAttribute("userId", user.getId());
            newSession.setAttribute("username", user.getUsername());

            LOGGER.info("User logged in successfully: " + user.getUsername());

            response.sendRedirect(request.getContextPath() + "/dashboard");

        } else {
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}