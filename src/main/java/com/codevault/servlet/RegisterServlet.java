package com.codevault.servlet;

import java.io.IOException;
import java.util.logging.Logger;

import com.codevault.dao.UserDAO;
import com.codevault.model.User;
import com.codevault.util.InputValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // --- Server-side input validation (never log passwords) ---
        if (!InputValidator.isValidUsername(username)) {
            request.setAttribute("error",
                    "Username must be 3-30 characters (letters, numbers, underscore).");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!InputValidator.isValidEmail(email)) {
            request.setAttribute("error", "Please provide a valid email address.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!InputValidator.isValidPassword(password)) {
            request.setAttribute("error",
                    "Password must be between 8 and 128 characters.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        // Check for duplicate username
        if (dao.usernameExists(username.trim())) {
            request.setAttribute("error", "Username is already taken.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check for duplicate email
        if (dao.emailExists(email.trim())) {
            request.setAttribute("error", "Email is already registered.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username.trim());
        user.setEmail(email.trim());
        user.setPassword(password); // DAO will hash it

        boolean result = dao.registerUser(user);

        if (result) {
            LOGGER.info("New user registered: " + username.trim());
            request.setAttribute("message", "Registration successful! Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}