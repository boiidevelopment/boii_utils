CREATE TABLE IF NOT EXISTS `utils_users` (
    `id` int NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `unique_id` VARCHAR(255) NOT NULL,
    `rank` ENUM('member', 'mod', 'admin', 'dev', 'owner') NOT NULL DEFAULT 'member',
    `vip` BOOLEAN NOT NULL DEFAULT 0,
    `priority` INT(11) NOT NULL DEFAULT 0,
    `character_slots` INT(11) NOT NULL DEFAULT 2,
    `license` VARCHAR(255) NOT NULL,
    `discord` VARCHAR(255),
    `tokens` JSON NOT NULL,
    `ip` VARCHAR(255) NOT NULL,
    `banned` BOOLEAN NOT NULL DEFAULT FALSE,
    `banned_by` VARCHAR(255) NOT NULL DEFAULT 'utils',
    `reason` TEXT DEFAULT NULL,
    `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    `deleted` BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (`unique_id`),
    KEY (`license`),
    KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `utils_bans` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `unique_id` VARCHAR(255) NOT NULL,
    `banned_by` VARCHAR(255) NOT NULL DEFAULT 'utils',
    `reason` TEXT DEFAULT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    `expires_at` TIMESTAMP NULL DEFAULT NULL,
    `expired` BOOLEAN NOT NULL DEFAULT FALSE,
    `appealed` BOOLEAN NOT NULL DEFAULT FALSE,
    `appealed_by` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `utils_licences` (
    `identifier` VARCHAR(255) NOT NULL,
    `licence_id` VARCHAR(50) NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `theory` BOOLEAN DEFAULT FALSE,
    `practical` BOOLEAN DEFAULT FALSE,
    `theory_date` DATETIME NULL,
    `practical_date` DATETIME NULL,
    `points` INT UNSIGNED NOT NULL DEFAULT 0,
    `max_points` INT UNSIGNED NOT NULL DEFAULT 12,
    `revoked` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`identifier`, `licence_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `utils_xp` (
    `identifier` VARCHAR(255) NOT NULL,
    `xp_id` VARCHAR(50) NOT NULL,
    `type` ENUM('work', 'skill', 'reputation') NOT NULL,
    `category` VARCHAR(50) NOT NULL,
    `level` INT UNSIGNED NOT NULL DEFAULT 1,
    `xp` INT UNSIGNED NOT NULL DEFAULT 0,
    `xp_required` INT UNSIGNED NOT NULL DEFAULT 1000,
    `growth_factor` DECIMAL(4,2) NOT NULL DEFAULT 1.5,
    `max_level` INT UNSIGNED DEFAULT 20,
    `decay_rate` INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`identifier`, `xp_id`, `type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
