-- =======================================================
-- CodeVault Database Initialization & Schema Script
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
-- Dedicated Least-Privilege Application User
-- CodeVault application only requires CRUD operations
-- (Executed when running with root administrative context)
-- -------------------------------------------------------
CREATE USER IF NOT EXISTS 'codevault_user'@'%' IDENTIFIED BY 'codevault_password_change_me';
GRANT SELECT, INSERT, UPDATE, DELETE ON `codevault`.* TO 'codevault_user'@'%';
FLUSH PRIVILEGES;
