package com.codevault.servlet;

import java.io.IOException;

import com.codevault.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String login = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("Login = " + login);
        System.out.println("Password = " + password);

        UserDAO dao = new UserDAO();

        boolean valid = dao.validateUser(login, password);

        if (valid) {
            response.sendRedirect("dashboard");
        } else {
            response.getWriter().println("Invalid Username/Email or Password");
        }
    }
}