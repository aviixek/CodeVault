package com.codevault.servlet;

import java.io.IOException;
import java.util.logging.Logger;

import com.codevault.dao.SnippetDAO;
import com.codevault.util.InputValidator;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/deleteSnippet")
public class DeleteSnippetServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(DeleteSnippetServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Authenticated session check (via AuthFilter and session attribute)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String idParam = request.getParameter("id");

        // 2. Input validation
        if (!InputValidator.isValidSnippetId(idParam)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid snippet ID.");
            return;
        }

        int id = InputValidator.parseSnippetId(idParam);

        // 3. Ownership-enforced database deletion (DAO checks WHERE id=? AND user_id=?)
        SnippetDAO dao = new SnippetDAO();
        boolean deleted = dao.deleteSnippet(id, userId);

        if (!deleted) {
            LOGGER.warning("Delete snippet failed or forbidden: ID=" + id + " for userId=" + userId);
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Snippet not found or unauthorized.");
            return;
        }

        LOGGER.info("Snippet deleted successfully: ID=" + id + " by userId=" + userId);
        response.sendRedirect(request.getContextPath() + "/dashboard");
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        // Disallow deletion via GET requests
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "DELETE operation requires POST request.");
    }
}