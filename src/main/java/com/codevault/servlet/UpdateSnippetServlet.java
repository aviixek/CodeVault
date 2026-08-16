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

@WebServlet("/updateSnippet")
public class UpdateSnippetServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(UpdateSnippetServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Auth is handled by AuthFilter
        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");

        String idParam = request.getParameter("id");

        // Validate ID
        if (!InputValidator.isValidSnippetId(idParam)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid snippet ID.");
            return;
        }

        int id = InputValidator.parseSnippetId(idParam);

        String title = request.getParameter("title");
        String language = request.getParameter("language");
        String description = request.getParameter("description");
        String code = request.getParameter("code");

        // Server-side validation
        if (!InputValidator.isValidTitle(title)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid title.");
            return;
        }
        if (!InputValidator.isValidLanguage(language)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid language.");
            return;
        }
        if (!InputValidator.isValidCode(code)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Code is required.");
            return;
        }

        Snippet snippet = new Snippet();
        snippet.setId(id);
        snippet.setTitle(title.trim());
        snippet.setLanguage(language);
        snippet.setDescription(description != null ? description.trim() : "");
        snippet.setCode(code);

        SnippetDAO dao = new SnippetDAO();

        // Ownership is enforced in the SQL query: UPDATE ... WHERE id=? AND user_id=?
        boolean updated = dao.updateSnippet(snippet, userId);

        if (!updated) {
            // Either snippet doesn't exist or doesn't belong to this user
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Snippet not found.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}