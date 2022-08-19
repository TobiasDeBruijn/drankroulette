use std::io;
use actix_web::{App, HttpServer};
use dal::fs::Config;
use dal::mysql::Mysql;
use crate::data::{AppData, WebData};
use crate::routes::Routable;

mod routes;
mod error;
mod data;

pub async fn start_actix(mysql: Mysql, config: Config) -> io::Result<()> {
    let data = WebData::new(AppData {
        mysql,
        config
    });

    HttpServer::new(move || App::new()
        .app_data(data.clone())
        .wrap(actix_cors::Cors::permissive())
        .wrap(tracing_actix_web::TracingLogger::default())
        .configure(routes::Router::configure)
    )
    .bind("0.0.0.0:8080")?
    .run()
    .await
}