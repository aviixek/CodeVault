package com.codevault;

import at.favre.lib.crypto.bcrypt.BCrypt;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class PasswordSecurityTest {

    @Test
    public void testBCryptHashingAndVerification() {
        String plainPassword = "SuperSecretPassword123!";

        // Hash with BCrypt cost 12
        String hash1 = BCrypt.withDefaults().hashToString(12, plainPassword.toCharArray());
        String hash2 = BCrypt.withDefaults().hashToString(12, plainPassword.toCharArray());

        assertNotNull(hash1);
        assertNotNull(hash2);
        assertTrue(hash1.startsWith("$2a$") || hash1.startsWith("$2b$"));
        // Hashes should differ due to unique salts
        assertNotEquals(hash1, hash2, "BCrypt must generate unique salts for each hash");

        // Verify correct password matches
        BCrypt.Result result1 = BCrypt.verifyer().verify(plainPassword.toCharArray(), hash1);
        assertTrue(result1.verified, "Valid password must verify against BCrypt hash");

        BCrypt.Result result2 = BCrypt.verifyer().verify(plainPassword.toCharArray(), hash2);
        assertTrue(result2.verified, "Valid password must verify against second BCrypt hash");

        // Verify wrong password fails
        BCrypt.Result wrongResult = BCrypt.verifyer().verify("WrongPassword!".toCharArray(), hash1);
        assertFalse(wrongResult.verified, "Incorrect password must fail verification");
    }

    @Test
    public void testLegacyPasswordFormatIdentification() {
        String legacyPlaintext = "123456";
        String bcryptHash = "$2a$12$e86gJ0VwS7/1.7U5tE81/OTe0fFzBszZ7k/3M4iJm6/0jG3Vw7h.S";

        assertFalse(legacyPlaintext.startsWith("$2"), "Plaintext password is identified as legacy");
        assertTrue(bcryptHash.startsWith("$2"), "BCrypt hash is identified correctly");
    }
}
