use actix_web::web;
use actix_web::web::ServiceConfig;
use crate::routes::routable::Routable;

mod generate;

pub struct Router;

impl Routable for Router {
    fn configure(cfg: &mut ServiceConfig) {
        cfg.service(web::scope("/token")
            .route("/generate", web::post().to(generate::generate))
        );
    }
}