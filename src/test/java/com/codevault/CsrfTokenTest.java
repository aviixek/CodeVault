package com.codevault;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import com.codevault.filter.CsrfFilter;

public class CsrfTokenTest {

    @Test
    public void testGenerateTokenUniquenessAndFormat() {
        String token1 = CsrfFilter.generateToken();
        String token2 = CsrfFilter.generateToken();

        assertNotNull(token1);
        assertNotNull(token2);
        assertNotEquals(token1, token2, "Each generated token must be cryptographically unique");
        assertTrue(token1.length() >= 32, "CSRF token should be at least 32 characters in base64 URL encoding");
    }
}
