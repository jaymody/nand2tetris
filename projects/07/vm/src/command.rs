#[derive(Debug)]
pub enum Command {
    Operation(Operation),
    Memory(Memory),
    Branch(Branch),
    Function(Function),
}

#[derive(Debug)]
pub enum Operation {
    Add,
    Sub,
    Neg,
    Eq,
    Gt,
    Lt,
    And,
    Or,
    Not,
}

#[derive(Debug)]
pub enum Memory {
    Push(Segment, u16),
    Pop(Segment, u16),
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

#[derive(Debug)]
pub enum Branch {
    Label(String),
    Goto(String),
    IfGoto(String),
}

#[derive(Debug)]
pub enum Function {
    Function(String, u16),
    Call(String, u16),
    Return,
}
