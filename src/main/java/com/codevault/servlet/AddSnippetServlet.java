package com.codevault.servlet;

import java.io.IOException;
import java.util.logging.Logger;

import com.codevault.dao.SnippetDAO;
import com.codevault.model.Snippet;
import com.codevault.util.InputValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addSnippet")
public class AddSnippetServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AddSnippetServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        // Serve the add snippet form
        request.getRequestDispatcher("/WEB-INF/views/addSnippet.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Auth is handled by AuthFilter; get userId from session (never from request)
        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");

        String title = request.getParameter("title");
        String language = request.getParameter("language");
        String description = request.getParameter("description");
        String code = request.getParameter("code");

        // Server-side validation
        if (!InputValidator.isValidTitle(title)) {
            request.setAttribute("error", "Title is required (max 200 characters).");
            request.getRequestDispatcher("/WEB-INF/views/addSnippet.jsp")
                   .forward(request, response);
            return;
        }

        if (!InputValidator.isValidLanguage(language)) {
            request.setAttribute("error", "Please select a valid programming language.");
            request.getRequestDispatcher("/WEB-INF/views/addSnippet.jsp")
                   .forward(request, response);
            return;
        }

        if (!InputValidator.isValidCode(code)) {
            request.setAttribute("error", "Code snippet is required.");
            request.getRequestDispatcher("/WEB-INF/views/addSnippet.jsp")
                   .forward(request, response);
            return;
        }

        Snippet snippet = new Snippet();
        snippet.setTitle(title.trim());
        snippet.setLanguage(language);
        snippet.setDescription(description != null ? description.trim() : "");
        snippet.setCode(code);
        snippet.setUserId(userId);

        SnippetDAO dao = new SnippetDAO();
        boolean result = dao.addSnippet(snippet);

        if (result) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("error", "Failed to save snippet. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/addSnippet.jsp")
                   .forward(request, response);
        }
    }
}