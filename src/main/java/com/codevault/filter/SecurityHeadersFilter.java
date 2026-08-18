package com.codevault.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Adds security headers to all HTTP responses.
 * Enforces strict Content-Security-Policy with zero 'unsafe-inline' scripts and styles.
 */
@WebFilter(urlPatterns = "/*")
public class SecurityHeadersFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Prevent MIME-type sniffing
        httpResponse.setHeader("X-Content-Type-Options", "nosniff");

        // Prevent clickjacking
        httpResponse.setHeader("X-Frame-Options", "DENY");

        // Control referrer information
        httpResponse.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");

        // Restrict browser features
        httpResponse.setHeader("Permissions-Policy", "camera=(), microphone=(), geolocation=()");

        // Strict Content Security Policy:
        // - script-src 'self' (No inline scripts allowed)
        // - style-src 'self' (No inline styles allowed, all styles in style.css)
        // - font-src 'self' (Local and system fonts only, no external font CDNs)
        // - img-src 'self' data:
        // - connect-src 'self'
        // - frame-ancestors 'none'
        // - form-action 'self'
        // - base-uri 'self'
        httpResponse.setHeader("Content-Security-Policy",
                "default-src 'self'; " +
                "script-src 'self'; " +
                "style-src 'self'; " +
                "font-src 'self'; " +
                "img-src 'self' data:; " +
                "connect-src 'self'; " +
                "frame-ancestors 'none'; " +
                "form-action 'self'; " +
                "base-uri 'self'"
        );

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No destruction logic needed
    }
}
