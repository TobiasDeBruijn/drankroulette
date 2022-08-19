use std::collections::HashMap;
use actix_multiresponse::Payload;
use dal::mysql::{Game, GameBuilder, PhysicalObject};
use crate::data::WebData;
use crate::routes::fingerprint::Fingerprint;
use proto::{PostGameCreateRequest, PostGameCreateResponse};
use crate::error::{WebError, WebResult};

pub async fn create(data: WebData, fp: Fingerprint, payload: Payload<PostGameCreateRequest>) -> WebResult<Payload<PostGameCreateResponse>> {
    let game = payload.game.as_ref().unwrap();
    let phy_requirments = game.physical_requirments.iter()
        .map(|x| {
            Ok((
                PhysicalObject::try_from(x.object.clone()).map_err(|_| WebError::BadRequest)?,
                x.count as u8
            ))
        })
        .collect::<WebResult<HashMap<_, _>>>()?;

    let game = Game::new(data.mysql.clone(), fp.0.clone(), GameBuilder {
        name: game.name.clone(),
        outline: game.outline.clone(),
        game_rules: game.game_rules.clone(),
        min_persons: game.min_persons.map(|x| x as u8),
        max_persons: game.max_persons.map(|x| x as u8),
        physical_requirments: phy_requirments,
    }).await?;

    Ok(Payload(PostGameCreateResponse {
        id: game.id
    }))
}

