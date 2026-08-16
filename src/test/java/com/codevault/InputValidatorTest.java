package com.codevault;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import com.codevault.util.InputValidator;

public class InputValidatorTest {

    @Test
    public void testValidUsernames() {
        assertTrue(InputValidator.isValidUsername("developer"));
        assertTrue(InputValidator.isValidUsername("dev_123"));
        assertTrue(InputValidator.isValidUsername("User_Name"));
    }

    @Test
    public void testInvalidUsernames() {
        assertFalse(InputValidator.isValidUsername(null));
        assertFalse(InputValidator.isValidUsername(""));
        assertFalse(InputValidator.isValidUsername("ab")); // too short (< 3)
        assertFalse(InputValidator.isValidUsername("user with spaces"));
        assertFalse(InputValidator.isValidUsername("user<script>"));
        assertFalse(InputValidator.isValidUsername("user' OR '1'='1")); // SQL injection attempt
    }

    @Test
    public void testValidEmails() {
        assertTrue(InputValidator.isValidEmail("user@example.com"));
        assertTrue(InputValidator.isValidEmail("first.last@domain.co.uk"));
        assertTrue(InputValidator.isValidEmail("dev+code@sub.domain.org"));
    }

    @Test
    public void testInvalidEmails() {
        assertFalse(InputValidator.isValidEmail(null));
        assertFalse(InputValidator.isValidEmail(""));
        assertFalse(InputValidator.isValidEmail("plainaddress"));
        assertFalse(InputValidator.isValidEmail("@missingusername.com"));
        assertFalse(InputValidator.isValidEmail("user@.com"));
        assertFalse(InputValidator.isValidEmail("user@domain..com"));
    }

    @Test
    public void testPasswordConstraints() {
        assertTrue(InputValidator.isValidPassword("StrongPass123!"));
        assertTrue(InputValidator.isValidPassword("12345678")); // 8 chars min
        assertFalse(InputValidator.isValidPassword("1234567")); // 7 chars (too short)
        assertFalse(InputValidator.isValidPassword(null));
        assertFalse(InputValidator.isValidPassword(""));
    }

    @Test
    public void testSnippetIdParsingAndValidation() {
        assertTrue(InputValidator.isValidSnippetId("1"));
        assertTrue(InputValidator.isValidSnippetId("42"));
        assertEquals(42, InputValidator.parseSnippetId("42"));

        // Malformed IDs rejection
        assertFalse(InputValidator.isValidSnippetId("0"));
        assertFalse(InputValidator.isValidSnippetId("-1"));
        assertFalse(InputValidator.isValidSnippetId("abc"));
        assertFalse(InputValidator.isValidSnippetId("1; DROP TABLE snippets;"));
        assertFalse(InputValidator.isValidSnippetId("99999999999999999999999999")); // Overflow
        assertEquals(-1, InputValidator.parseSnippetId("invalid"));
    }

    @Test
    public void testLanguageWhitelist() {
        assertTrue(InputValidator.isValidLanguage("Java"));
        assertTrue(InputValidator.isValidLanguage("Python"));
        assertTrue(InputValidator.isValidLanguage("JavaScript"));
        assertTrue(InputValidator.isValidLanguage("MySQL"));
        assertTrue(InputValidator.isValidLanguage("HTML"));
        assertTrue(InputValidator.isValidLanguage("CSS"));
        assertTrue(InputValidator.isValidLanguage("Other"));

        assertFalse(InputValidator.isValidLanguage("MaliciousLang<script>"));
        assertFalse(InputValidator.isValidLanguage(""));
        assertFalse(InputValidator.isValidLanguage(null));
    }

    @Test
    public void testSanitizeForLog() {
        assertEquals("[null]", InputValidator.sanitizeForLog(null));
        assertEquals("Clean Text", InputValidator.sanitizeForLog("Clean Text"));
        assertEquals("Line 1  Line 2", InputValidator.sanitizeForLog("Line 1\n\rLine 2"));
    }
}
