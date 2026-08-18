-- =======================================================
-- CodeVault Safe Database Monitoring & Inspection Queries
-- For use via MySQL CLI or MySQL Workbench (127.0.0.1:3307)
-- Passwords and password hashes are never included.
-- =======================================================

USE codevault;

-- 1. View registered users (without passwords/hashes)
SELECT id, username, email, created_at
FROM users
ORDER BY id DESC;

-- 2. View saved code records
SELECT id, user_id, title, language, created_at
FROM snippets
ORDER BY id DESC;

-- 3. View user activity and security audit trail
SELECT
    a.id,
    u.username,
    a.event_type,
    a.success,
    a.ip_address,
    a.created_at
FROM login_audit a
LEFT JOIN users u ON a.user_id = u.id
ORDER BY a.id DESC;
