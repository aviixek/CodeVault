package com.codevault.servlet;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import com.codevault.dao.SnippetDAO;
import com.codevault.model.Snippet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/addSnippet")
public class AddSnippetServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String language = request.getParameter("language");
        String description = request.getParameter("description");
        String code = request.getParameter("code");
        HttpSession session = request.getSession(false);

        int userId = (Integer) session.getAttribute("userId");

        Snippet snippet = new Snippet();

        snippet.setTitle(title);
        snippet.setLanguage(language);
        snippet.setDescription(description);
        snippet.setCode(code);
        snippet.setUserId(userId);

        SnippetDAO dao = new SnippetDAO();

        boolean result = dao.addSnippet(snippet);

        if(result) {

            response.sendRedirect("dashboard");

        } else {

            response.getWriter().println("Snippet Not Saved!");

        }

    }

}