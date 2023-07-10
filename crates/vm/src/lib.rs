mod opcode;
mod parser;
mod translator;

use parser::parse;
use translator::Translator;

pub fn translate(text: &str, sys_init: bool) -> String {
    let mut translator = Translator::init(sys_init);
    let opcodes = parse(text);
    for opcode in opcodes {
        translator.emit_opcode(opcode);
    }
    translator.assembly()
}
