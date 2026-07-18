package com.codevault.servlet;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;

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

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        SnippetDAO dao = new SnippetDAO();

        List<Snippet> snippets = dao.getAllSnippets(userId);
        int totalSnippets = snippets.size();

        List<String> languages = dao.getAllLanguages(userId);
        Timestamp lastUpdated = dao.getLastUpdated(userId);

        String formattedDate = "Never";

        if (lastUpdated != null) {
            DateTimeFormatter formatter =
                    DateTimeFormatter.ofPattern("dd MMM yyyy");

            formattedDate = lastUpdated.toLocalDateTime()
                                       .format(formatter);
        }

        request.setAttribute("lastUpdated", formattedDate);

        request.setAttribute("totalSnippets", totalSnippets);
        request.setAttribute("snippets", snippets);
        request.setAttribute("languages", languages);

        request.getRequestDispatcher("dashboard.jsp")
               .forward(request, response);
    }

}