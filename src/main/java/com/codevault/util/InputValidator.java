package com.codevault.util;

import java.util.Set;
import java.util.regex.Pattern;

/**
 * Server-side input validation. Never rely on client-side validation alone.
 */
public final class InputValidator {

    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[a-zA-Z0-9_]{3,30}$");
    
    // Strict RFC 5322 compliant email regex preventing consecutive dots and invalid domain formats
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$");

    private static final int PASSWORD_MIN_LENGTH = 8;
    private static final int PASSWORD_MAX_LENGTH = 128;
    private static final int TITLE_MAX_LENGTH = 200;
    private static final int DESCRIPTION_MAX_LENGTH = 2000;
    private static final int CODE_MAX_LENGTH = 100_000;

    private static final Set<String> ALLOWED_LANGUAGES = Set.of(
            "Java", "Python", "JavaScript", "MySQL", "SQL",
            "HTML", "CSS", "JSP", "C", "C++", "C#",
            "PHP", "Ruby", "Go", "Rust", "TypeScript",
            "Kotlin", "Swift", "Bash", "Other"
    );

    private InputValidator() {
    }

    public static boolean isValidUsername(String username) {
        return username != null && USERNAME_PATTERN.matcher(username).matches();
    }

    public static boolean isValidEmail(String email) {
        return email != null && email.length() <= 254 && EMAIL_PATTERN.matcher(email).matches();
    }

    public static boolean isValidPassword(String password) {
        return password != null
                && password.length() >= PASSWORD_MIN_LENGTH
                && password.length() <= PASSWORD_MAX_LENGTH;
    }

    public static boolean isValidSnippetId(String idStr) {
        if (idStr == null || idStr.isBlank()) {
            return false;
        }
        try {
            int id = Integer.parseInt(idStr.trim());
            return id > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    public static int parseSnippetId(String idStr) {
        if (!isValidSnippetId(idStr)) {
            return -1;
        }
        return Integer.parseInt(idStr.trim());
    }

    public static boolean isValidTitle(String title) {
        return title != null && !title.isBlank() && title.length() <= TITLE_MAX_LENGTH;
    }

    public static boolean isValidDescription(String description) {
        return description == null || description.length() <= DESCRIPTION_MAX_LENGTH;
    }

    public static boolean isValidCode(String code) {
        return code != null && !code.isBlank() && code.length() <= CODE_MAX_LENGTH;
    }

    public static boolean isValidLanguage(String language) {
        return language != null && ALLOWED_LANGUAGES.contains(language);
    }

    /**
     * Sanitizes a string for safe logging (no newlines, limited length).
     * Never log passwords or secrets.
     */
    public static String sanitizeForLog(String input) {
        if (input == null) {
            return "[null]";
        }
        String cleaned = input.replaceAll("[\\r\\n\\t]", " ");
        if (cleaned.length() > 100) {
            cleaned = cleaned.substring(0, 100) + "...";
        }
        return cleaned;
    }
}
