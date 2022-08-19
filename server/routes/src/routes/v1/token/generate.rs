use actix_multiresponse::Payload;
use crate::error::WebResult;
use proto::PostGenerateTokenResponse;

pub async fn generate() -> WebResult<Payload<PostGenerateTokenResponse>> {
    let token = dal::generate_string(64);

    Ok(Payload(PostGenerateTokenResponse {
        token
    }))
}