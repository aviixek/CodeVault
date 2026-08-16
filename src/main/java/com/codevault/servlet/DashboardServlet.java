package com.codevault.servlet;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.logging.Logger;

import com.codevault.dao.SnippetDAO;
import com.codevault.model.Snippet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DashboardServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Auth check is handled by AuthFilter, but we still need the userId
        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");

        SnippetDAO dao = new SnippetDAO();

        List<Snippet> snippets = dao.getAllSnippets(userId);
        int totalSnippets = snippets.size();

        List<String> languages = dao.getAllLanguages(userId);
        Timestamp lastUpdated = dao.getLastUpdated(userId);

        String formattedDate = "Never";
        if (lastUpdated != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMM yyyy");
            formattedDate = lastUpdated.toLocalDateTime().format(formatter);
        }

        request.setAttribute("lastUpdated", formattedDate);
        request.setAttribute("totalSnippets", totalSnippets);
        request.setAttribute("snippets", snippets);
        request.setAttribute("languages", languages);

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp")
               .forward(request, response);
    }
}