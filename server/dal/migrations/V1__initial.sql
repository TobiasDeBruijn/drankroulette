CREATE TABLE games (
    id VARCHAR(32) NOT NULL,
    creator VARCHAR(64) NOT NULL,
    name VARCHAR(32) NOT NULL,
    game_rules TEXT NOT NULL,
    min_persons SMALLINT DEFAULT NULL,
    max_persons SMALLINT DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE game_physical_requirments (
    id INT NOT NULL AUTO_INCREMENT,
    game_id VARCHAR(32) NOT NULL,
    object VARCHAR(32) NOT NULL,
    count INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (game_id) REFERENCES games(id)
);