use std::collections::HashMap;
use mysql_async::prelude::Queryable;
use mysql_async::{params, TxOpts};
use crate::generate_string;
use crate::mysql::{Mysql, MysqlResult};

pub struct Game {
    mysql: Mysql,
    pub id: String,
    pub creator: String,
    pub name: String,
    pub outline: String,
    pub game_rules: String,
    pub min_persons: Option<u8>,
    pub max_persons: Option<u8>,
    pub physical_requirments: HashMap<PhysicalObject, u8>,
}

#[derive(Debug, Clone, PartialOrd, PartialEq, Ord, Eq, Hash)]
pub enum PhysicalObject {
    CardSet,
    Dice,
    Scoreboard,
    RedCups,
}

impl ToString for PhysicalObject {
    fn to_string(&self) -> String {
        match self {
            Self::CardSet => "CardSet",
            Self::Dice => "Dice",
            Self::Scoreboard => "Scoreboard",
            Self::RedCups => "RedCups",
        }.to_string()
    }
}

impl TryFrom<String> for PhysicalObject {
    type Error = ();

    fn try_from(value: String) -> Result<Self, Self::Error> {
        Ok(match value.as_str() {
            "CardSet" => Self::CardSet,
            "Dice" => Self::Dice,
            "Scoreboard" => Self::Scoreboard,
            "RedCups" => Self::RedCups,
            _ => return Err(())
        })
    }
}

pub struct GameBuilder {
    pub name: String,
    pub outline: String,
    pub game_rules: String,
    pub min_persons: Option<u8>,
    pub max_persons: Option<u8>,
    pub physical_requirments: HashMap<PhysicalObject, u8>,
}

impl Game {
    pub async fn new(mysql: Mysql, creator: String, game: GameBuilder) -> MysqlResult<Self> {
        let mut tx = mysql.start_transaction(TxOpts::default()).await?;
        let id = generate_string(32);

        tx.exec_drop("INSERT INTO games (id, creator, name, outline, game_rules, min_persons, max_persons) VALUES (:id, :creator, :name, :outline, :game_rules, :min_persons, :max_persons)", params! {
            "id" => &id,
            "creator" => &creator,
            "name" => &game.name,
            "outline" => &game.outline,
            "game_rules" => &game.game_rules,
            "min_persons" => &game.min_persons,
            "max_persons" => &game.max_persons,
        }).await?;

        for (k, v) in &game.physical_requirments {
            tx.exec_drop("INSERT INTO game_physical_requirments (game_id, object, count) VALUES (:game_id, :object, :count)", params! {
                "game_id" => &id,
                "object" => k.to_string(),
                "count" => v,
            }).await?;
        }

        tx.commit().await?;

        Ok(Self {
            mysql,
            id,
            creator,
            name: game.name,
            outline: game.outline,
            game_rules: game.game_rules,
            min_persons: game.min_persons,
            max_persons: game.max_persons,
            physical_requirments: game.physical_requirments,
        })
    }
}