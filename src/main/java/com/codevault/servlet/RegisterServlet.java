package com.codevault.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.codevault.dao.UserDAO;
import com.codevault.model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public RegisterServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        System.out.println("Username = " + username);
        System.out.println("Email = " + email);
        System.out.println("Password = " + password);

        User user = new User();

        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);

        UserDAO dao = new UserDAO();

        boolean result = dao.registerUser(user);

        if (result) {

            response.sendRedirect("login.jsp");

        } else {

            response.getWriter().println("Registration Failed!");

        }
    }
}