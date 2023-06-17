mod command;
mod parser;

use parser::parse;

pub fn translate(text: &str) -> String {
    parse(text)
        .into_iter()
        .map(|command| format!("{:?}", command))
        .collect::<Vec<String>>()
        .join("\n")
}
