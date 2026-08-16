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

@WebServlet("/editSnippet")
public class EditSnippetServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(EditSnippetServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request,
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

        SnippetDAO dao = new SnippetDAO();

        // Ownership check: getSnippetById requires userId
        Snippet snippet = dao.getSnippetById(id, userId);

        if (snippet == null) {
            // Return 404 instead of 403 to avoid revealing snippet existence to other users
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Snippet not found.");
            return;
        }

        request.setAttribute("snippet", snippet);
        request.getRequestDispatcher("/WEB-INF/views/editSnippet.jsp")
               .forward(request, response);
    }
}