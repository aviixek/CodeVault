package com.codevault;

import java.sql.Timestamp;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import com.codevault.model.Snippet;
import com.codevault.model.User;

public class ModelTest {

    @Test
    public void testUserModelGettersAndSetters() {
        User user = new User();
        user.setId(1);
        user.setUsername("testuser");
        user.setEmail("test@example.com");
        user.setPassword("securePassword123");
        Timestamp now = new Timestamp(System.currentTimeMillis());
        user.setCreatedAt(now);

        assertEquals(1, user.getId());
        assertEquals("testuser", user.getUsername());
        assertEquals("test@example.com", user.getEmail());
        assertEquals("securePassword123", user.getPassword());
        assertEquals(now, user.getCreatedAt());
    }

    @Test
    public void testSnippetModelPreviewCodeTruncation() {
        Snippet snippet = new Snippet();
        snippet.setCode("line1\nline2\nline3\nline4\nline5\nline6\nline7\nline8");

        String preview = snippet.getPreviewCode();
        assertNotNull(preview);
        assertTrue(preview.contains("line1"));
        assertTrue(preview.contains("line6"));
        assertTrue(preview.endsWith("..."), "Preview should end with ellipsis when lines exceed 6");
        assertFalse(preview.contains("line7"));
    }

    @Test
    public void testSnippetModelPreviewCodeShort() {
        Snippet snippet = new Snippet();
        snippet.setCode("line1\nline2");

        String preview = snippet.getPreviewCode();
        assertEquals("line1\nline2", preview);
        assertFalse(preview.endsWith("..."));
    }

    @Test
    public void testSnippetModelNullCode() {
        Snippet snippet = new Snippet();
        snippet.setCode(null);

        assertEquals("", snippet.getPreviewCode());
    }
}