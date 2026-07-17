package com.codevault.servlet;

import java.io.IOException;
import java.util.List;

import com.codevault.dao.SnippetDAO;
import com.codevault.model.Snippet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        SnippetDAO dao = new SnippetDAO();

        List<Snippet> snippets = dao.getAllSnippets();

        request.setAttribute("snippets", snippets);

        request.getRequestDispatcher("dashboard.jsp")
               .forward(request, response);
    }

}