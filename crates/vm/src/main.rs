use vm::translate;

fn main() {
    let path = &std::env::args()
        .nth(1)
        .expect("must provide path to filename or directory");

    let metadata = std::fs::metadata(path).unwrap();
    let vm_text = if metadata.is_dir() {
        std::fs::read_dir(path)
            .unwrap()
            .map(|f| f.as_ref().unwrap().path())
            .filter(|p| p.extension().map_or(false, |ext| ext == "vm"))
            .map(|p| std::fs::read_to_string(p).unwrap())
            .collect::<Vec<String>>()
            .join("\n")
    } else if metadata.is_file() {
        std::fs::read_to_string(path).unwrap()
    } else {
        panic!("path is not file or dir")
    };

    let assembly_code = translate(&vm_text, metadata.is_dir());
    println!("{assembly_code}");
}
