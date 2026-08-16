-- =======================================================
-- CodeVault Database Initialization & Schema Script
-- Executed automatically on initial Docker volume creation
-- =======================================================

CREATE DATABASE IF NOT EXISTS `codevault`
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE `codevault`;

-- -------------------------------------------------------
-- Table: users
-- Passwords stored as BCrypt hashes ($2a$, $2b$, 60 chars)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------
-- Table: snippets
-- Snippet records linked to owning user_id
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS `snippets` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(200) NOT NULL,
    `language` VARCHAR(50) NOT NULL,
    `description` TEXT,
    `code` MEDIUMTEXT NOT NULL,
    `user_id` INT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_snippets_user_id` (`user_id`),
    KEY `idx_snippets_created_at` (`created_at`),
    CONSTRAINT `fk_snippets_user`
        FOREIGN KEY (`user_id`)
        REFERENCES `users` (`id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------
-- Table: login_audit
-- Security and authentication audit trail
-- (No passwords, hashes, session IDs, or tokens stored)
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS `login_audit` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `user_id` INT NULL,
    `event_type` VARCHAR(50) NOT NULL,
    `success` BOOLEAN NOT NULL,
    `ip_address` VARCHAR(45) NULL,
    `user_agent` VARCHAR(255) NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_audit_user_id` (`user_id`),
    KEY `idx_audit_event_type` (`event_type`),
    KEY `idx_audit_created_at` (`created_at`),
    CONSTRAINT `fk_audit_user`
        FOREIGN KEY (`user_id`)
        REFERENCES `users` (`id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------
-- Least-Privilege Grants
-- Note: MySQL image automatically creates MYSQL_USER with MYSQL_PASSWORD.
-- Grants below ensure codevault_user has exact required permissions.
-- -------------------------------------------------------
GRANT SELECT, INSERT, UPDATE, DELETE ON `codevault`.* TO 'codevault_user'@'%';
FLUSH PRIVILEGES;
