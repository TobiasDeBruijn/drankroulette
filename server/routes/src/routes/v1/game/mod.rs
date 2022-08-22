use actix_web::web;
use actix_web::web::ServiceConfig;
use crate::routes::routable::Routable;

mod create;
mod delete;
mod get;
mod list;
mod update;

pub struct Router;

impl Routable for Router {
    fn configure(cfg: &mut ServiceConfig) {
        cfg.service(web::scope("/game")
            .route("/create", web::post().to(create::create))
            .route("/list", web::get().to(list::list))
        );
    }
}