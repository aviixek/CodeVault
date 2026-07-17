package com.codevault.servlet;

import java.io.IOException;
import com.codevault.model.User;
import jakarta.servlet.http.HttpSession;

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

        User user = dao.validateUser(login, password);

        if (user != null) {

            HttpSession session = request.getSession();

            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());

            response.sendRedirect("dashboard");

        } else {

            request.setAttribute("error", "Invalid Username or Password");
            request.getRequestDispatcher("login.jsp").forward(request, response);

        }
    }
}