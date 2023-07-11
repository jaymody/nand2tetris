use std::path::PathBuf;

use vm::Translator;

fn main() {
    let path_str = &std::env::args()
        .nth(1)
        .expect("must provide path to filename or directory");
    let path = PathBuf::from(path_str);
    let is_dir = path.is_dir();

    let files = if is_dir {
        std::fs::read_dir(path)
            .unwrap()
            .map(|f| f.as_ref().unwrap().path())
            .filter(|p| p.extension().map_or(false, |ext| ext == "vm"))
            .collect()
    } else if path.is_file() {
        vec![path]
    } else {
        panic!("path is not file or dir")
    };

    let assembly = Translator::translate(files, is_dir);
    println!("{assembly}")
}
