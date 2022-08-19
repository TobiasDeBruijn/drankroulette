use rand::Rng;

pub mod fs;
pub mod mysql;

pub fn generate_string(len: usize) -> String {
    rand::thread_rng().sample_iter(rand::distributions::Alphanumeric).take(len).map(char::from).collect()
}