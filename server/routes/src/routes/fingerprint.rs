use std::future::Future;
use std::pin::Pin;
use actix_web::{FromRequest, HttpRequest};
use actix_web::dev::Payload;
use crate::error::WebError;

#[derive(Debug)]
pub struct Fingerprint(pub String);

impl FromRequest for Fingerprint {
    type Error = WebError;
    type Future = Pin<Box<dyn Future<Output=Result<Self, Self::Error>>>>;

    fn from_request(req: &HttpRequest, _: &mut Payload) -> Self::Future {
        let req = req.clone();
        Box::pin(async move {
            let authorization = req.headers()
                .get("authorization")
                .ok_or(WebError::Unauthorized)?
                .to_str()
                .map_err(|_| WebError::Unauthorized)?
                .to_string();

            Ok(Self(authorization))
        })
    }
}