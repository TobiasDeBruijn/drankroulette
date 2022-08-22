use actix_multiresponse::Payload;
use proto::GetGameListResponse;
use crate::error::WebResult;
use crate::routes::fingerprint::Fingerprint;
use crate::WebData;

pub async fn list(data: WebData, _: Fingerprint) -> WebResult<Payload<GetGameListResponse>> {
    let games = dal::mysql::Game::list(data.mysql.clone()).await?;

    let games = games.into_iter()
        .map(|game| {
            proto::Game {
                id: game.id,
                name: game.name,
                outline: game.outline,
                game_rules: game.game_rules,
                min_persons: game.min_persons.map(|x| x as u32),
                max_persons: game.max_persons.map(|x| x as u32),
                physical_requirments: game.physical_requirments.into_iter()
                    .map(|(k, v)| proto::PhysicalRequirment {
                        object: k.to_string(),
                        count: v as u32,
                    })
                    .collect::<Vec<_>>(),
                system_provided: Some(game.creator.eq(&data.config.id.game_creator_sys_id))
            }
        })
        .collect::<Vec<_>>();

    Ok(Payload(GetGameListResponse {
        games
    }))
}