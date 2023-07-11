mod opcode;
mod parser;
mod translator;

use parser::parse;
use translator::{emit_init, emit_opcode};

pub fn translate(text: &str, goto_sys_init: bool) -> String {
    let opcodes = parse(text);

    let mut assembly = emit_init(goto_sys_init);
    for opcode in opcodes {
        assembly.push_str(&emit_opcode(opcode));
    }
    assembly
}
