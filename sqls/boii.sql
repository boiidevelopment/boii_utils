-- Player Skills Table
CREATE TABLE IF NOT EXISTS `player_skills` (
    `unique_id` varchar(255) NOT NULL,
    `char_id` int(1) NOT NULL DEFAULT 1,
    `skills` json DEFAULT '{}',
    CONSTRAINT `fk_player_skills_players` FOREIGN KEY (`unique_id`, `char_id`)
    REFERENCES `players` (`unique_id`, `char_id`) ON DELETE CASCADE,
    PRIMARY KEY (`unique_id`, `char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Player Reputation Table
CREATE TABLE IF NOT EXISTS `player_reputation` (
    `unique_id` varchar(255) NOT NULL,
    `char_id` int(1) NOT NULL DEFAULT 1,
    `reputation` json DEFAULT '{}',
    CONSTRAINT `fk_player_reputation_players` FOREIGN KEY (`unique_id`, `char_id`)
    REFERENCES `players` (`unique_id`, `char_id`) ON DELETE CASCADE,
    PRIMARY KEY (`unique_id`, `char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Player Licences Table
CREATE TABLE IF NOT EXISTS `player_licences` (
    `unique_id` varchar(255) NOT NULL,
    `char_id` int(1) NOT NULL DEFAULT 1,
    `licences` json DEFAULT '{}',
    CONSTRAINT `fk_player_licences_players` FOREIGN KEY (`unique_id`, `char_id`)
    REFERENCES `players` (`unique_id`, `char_id`) ON DELETE CASCADE,
    PRIMARY KEY (`unique_id`, `char_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
