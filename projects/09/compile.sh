set -e

if [[ $# -eq 1 ]]
  then
    rm -r _build/
    mkdir -p _build/
    cp ../../tools/OS/*.vm _build/
    cp "$1"/*.jack _build
    sh "../../tools/JackCompiler.sh" _build/
    python ../08/vm_opt.py _build/ > _build/Main.asm
  else
    echo "Must provide 1 argument (directory of program to compile)."
fi
