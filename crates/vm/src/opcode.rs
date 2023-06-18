#[derive(Debug)]

pub enum OpCode {
    // arithmetic/boolean ops
    Add,
    Sub,
    Neg,
    Eq,
    Gt,
    Lt,
    And,
    Or,
    Not,
    // memory ops
    Push(Segment, u16),
    Pop(Segment, u16),
    // branch ops
    Label(String),
    Goto(String),
    IfGoto(String),
    // function ops
    Function(String, u16),
    Call(String, u16),
    Return,
}

#[derive(Debug)]
pub enum Segment {
    Argument,
    Local,
    Static,
    Constant,
    This,
    That,
    Pointer,
    Temp,
}
