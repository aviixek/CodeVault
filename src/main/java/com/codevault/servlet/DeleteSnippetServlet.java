package com.codevault.servlet;

import java.io.IOException;

import com.codevault.dao.SnippetDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/deleteSnippet")
public class DeleteSnippetServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        SnippetDAO dao = new SnippetDAO();

        dao.deleteSnippet(id);

        response.sendRedirect("dashboard");

    }

}