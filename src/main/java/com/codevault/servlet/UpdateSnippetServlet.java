package com.codevault.servlet;

import java.io.IOException;

import com.codevault.dao.SnippetDAO;
import com.codevault.model.Snippet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/updateSnippet")
public class UpdateSnippetServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Snippet snippet = new Snippet();

        snippet.setId(Integer.parseInt(request.getParameter("id")));
        snippet.setTitle(request.getParameter("title"));
        snippet.setLanguage(request.getParameter("language"));
        snippet.setDescription(request.getParameter("description"));
        snippet.setCode(request.getParameter("code"));

        SnippetDAO dao = new SnippetDAO();

        dao.updateSnippet(snippet);

        response.sendRedirect("dashboard");

    }

}