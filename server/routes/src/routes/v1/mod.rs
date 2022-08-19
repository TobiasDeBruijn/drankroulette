use actix_web::web;
use actix_web::web::ServiceConfig;
use crate::routes::routable::Routable;

mod game;
mod token;

pub struct Router;

impl Routable for Router {
    fn configure(cfg: &mut ServiceConfig) {
        cfg.service(web::scope("/v1")
            .configure(token::Router::configure)
            .configure(game::Router::configure)
        );
    }
}