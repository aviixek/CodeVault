-- =======================================================
-- CodeVault Database Migration Script
-- Safe migration for existing installations to add login_audit
-- Does NOT drop tables or delete user/snippet records.
-- =======================================================

USE `codevault`;

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

-- Ensure required privileges
GRANT SELECT, INSERT, UPDATE, DELETE ON `codevault`.* TO 'codevault_user'@'%';
FLUSH PRIVILEGES;
