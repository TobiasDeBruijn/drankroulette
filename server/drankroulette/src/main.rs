use tracing::Level;

#[tokio::main]
async fn main() {
    configure_tracing();

    let cfg = dal::fs::Config::new().await.expect("Handling config");
    let mysql = dal::mysql::Mysql::new(
        &cfg.mysql.user,
        &cfg.mysql.db,
        &cfg.mysql.user,
        &cfg.mysql.password
    ).await.expect("Setting up MySQL");

    routes::start_actix(mysql, cfg).await.expect("Running Actix server");
}

fn configure_tracing() {
    let sub = tracing_subscriber::fmt()
        .compact()
        .with_max_level(Level::INFO)
        .finish();
    tracing::subscriber::set_global_default(sub).expect("Configuring logger");
}