mod opcode;
mod parser;
mod translator;

use parser::parse;
use translator::Translator;

pub fn translate(text: &str) -> String {
    Translator::translate(parse(text))
}
