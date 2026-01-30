use axum::{
    routing::get,
    Router
};

#[tokio::main]
async fn main()->Result<(),tokio::io::Error>{
    let app: Router = Router::new().route("/",get(|| async {"Hello world"}));
    let listener = tokio::net::TcpListener::bind("0.0.0.0:2000").await?;
    axum::serve(listener,app).await?;
    Ok(())
}

