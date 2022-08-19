use actix_web::http::StatusCode;
use actix_web::ResponseError;
use thiserror::Error;

pub type WebResult<T> = Result<T, WebError>;

#[derive(Debug, Error)]
#[allow(unused)]
pub enum WebError {
    #[error("{0}")]
    Mysql(#[from] dal::mysql::MysqlError),
    #[error("Not Found")]
    NotFound,
    #[error("Unauthorized")]
    Unauthorized,
    #[error("Bad Request")]
    BadRequest,
}

impl ResponseError for WebError {
    fn status_code(&self) -> StatusCode {
        match self {
            Self::Mysql(_) => StatusCode::INTERNAL_SERVER_ERROR,
            Self::NotFound => StatusCode::NOT_FOUND,
            Self::Unauthorized => StatusCode::UNAUTHORIZED,
            Self::BadRequest => StatusCode::BAD_REQUEST,
        }
    }
}