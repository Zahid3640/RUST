use error_chain::error_chain;
use reqwest::Request;
use select::document::Document;
use select::predicate::Name;

error_chain!{
    foreign_links{
    ReqError(reqwest::Error);
    IoError(std::io::Error);

}}

#[tokio::main]

async fn main()->Result<()> {
   let res=reqwest::get("https://doc.rust-lang.org/book/")
   .await?
   .text()
   .await?;

   Document::from(res.as_str())
   .find(Name("a"))
   .filter_map(|n|n.attr("href"))
   .for_each(|x| println!("{}",x));
Ok(())
}
