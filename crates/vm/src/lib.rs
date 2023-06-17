mod command;
mod parser;

use parser::parse;

pub fn translate(text: &str) -> Vec<String> {
    let commands = parse(text);
    let assembly_code = commands.into_iter().map(|c| format!("{:?}", c)).collect();
    assembly_code
}
