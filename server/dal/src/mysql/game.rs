use std::collections::HashMap;
use mysql_async::prelude::Queryable;
use mysql_async::{params, Params, Row, Transaction, TxOpts};
use crate::generate_string;
use crate::mysql::{Mysql, MysqlError, MysqlResult};

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

    pub async fn list(mysql: Mysql) -> MysqlResult<Vec<Self>> {
        let mut tx = mysql.start_transaction(TxOpts::default()).await?;
        let rows: Vec<Row> = tx.exec("SELECT id FROM games", Params::Empty).await?;

        let mut games = Vec::with_capacity(rows.len());
        for row in rows {
            let id = row.get("id").unwrap();
            let game = Self::get_by_id_tx(&mut tx, mysql.clone(), id).await?.unwrap();
            games.push(game)
        }

        Ok(games)
    }

    async fn get_by_id_tx(tx: &mut Transaction<'_>, mysql: Mysql, id: String) -> MysqlResult<Option<Self>> {
        let row: Row = match tx.exec_first("SELECT creator, name, outline, game_rules, min_persons, max_persons FROM games WHERE id = :id", params! {
            "id" => &id,
        }).await? {
            Some(x) => x,
            None => return Ok(None),
        };
        
        let phy_requirments: Vec<Row> = tx.exec("SELECT object, count FROM game_physical_requirments WHERE game_id = :game_id", params! {
            "game_id" => &id
        }).await?;

        Ok(Some(Self {
            mysql,
            id,
            creator: row.get("creator").unwrap(),
            name: row.get("name").unwrap(),
            outline: row.get("outline").unwrap(),
            game_rules: row.get("game_rules").unwrap(),
            min_persons: row.get("min_persons").unwrap(),
            max_persons: row.get("max_persons").unwrap(),
            physical_requirments: phy_requirments.into_iter()
                .map(|row| {
                    let object: String = row.get("object").unwrap();
                    Ok((
                        PhysicalObject::try_from(object).map_err(|_| MysqlError::InvalidState)?,
                        row.get("count").unwrap(),
                    ))
                })
                .collect::<MysqlResult<HashMap<PhysicalObject, u8>>>()?,
        }))
    }
}