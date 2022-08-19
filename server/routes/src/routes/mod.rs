use actix_web::web;
use actix_web::web::ServiceConfig;

mod v1;
mod fingerprint;
mod routable;

pub use routable::Routable;

pub struct Router;

impl Routable for Router {
    fn configure(cfg: &mut ServiceConfig) {
        cfg.service(web::scope("")
            .configure(v1::Router::configure)
        );
    }
}