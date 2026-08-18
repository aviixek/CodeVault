package com.codevault.filter;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Set;
import java.util.logging.Logger;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * CSRF protection filter. Generates and validates CSRF tokens for all
 * state-changing (POST) requests. Uses constant-time comparison to
 * prevent timing attacks.
 */
@WebFilter(urlPatterns = "/*")
public class CsrfFilter implements Filter {

    private static final Logger LOGGER = Logger.getLogger(CsrfFilter.class.getName());
    private static final String CSRF_TOKEN_SESSION_KEY = "csrf_token";
    private static final String CSRF_TOKEN_PARAM = "csrf_token";
    private static final SecureRandom RANDOM = new SecureRandom();

    // Paths that require CSRF validation on POST
    private static final Set<String> PROTECTED_PATHS = Set.of(
            "/LoginServlet", "/RegisterServlet",
            "/addSnippet", "/updateSnippet", "/deleteSnippet",
            "/logout"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Ensure a CSRF token exists in the session (generate if missing)
        HttpSession session = httpRequest.getSession(true);
        String csrfToken = (String) session.getAttribute(CSRF_TOKEN_SESSION_KEY);
        if (csrfToken == null) {
            csrfToken = generateToken();
            session.setAttribute(CSRF_TOKEN_SESSION_KEY, csrfToken);
        }

        // Make the token available to JSPs via request attribute
        httpRequest.setAttribute(CSRF_TOKEN_PARAM, csrfToken);

        // Validate CSRF token on POST requests to protected paths
        if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
            String path = httpRequest.getServletPath();
            if (isProtectedPath(path)) {
                String submittedToken = httpRequest.getParameter(CSRF_TOKEN_PARAM);
                if (!constantTimeEquals(csrfToken, submittedToken)) {
                    LOGGER.warning("CSRF token validation failed for path: " + path);
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Your request could not be verified. Please refresh the page and try again.");
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }

    /**
     * Generates a cryptographically secure random token.
     */
    public static String generateToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    /**
     * Constant-time string comparison to prevent timing attacks.
     */
    private boolean constantTimeEquals(String expected, String actual) {
        if (expected == null || actual == null) {
            return false;
        }
        try {
            byte[] expectedBytes = expected.getBytes("UTF-8");
            byte[] actualBytes = actual.getBytes("UTF-8");
            return MessageDigest.isEqual(expectedBytes, actualBytes);
        } catch (Exception e) {
            return false;
        }
    }

    private boolean isProtectedPath(String path) {
        return PROTECTED_PATHS.contains(path);
    }
}
