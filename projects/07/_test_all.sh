#!/usr/bin/env bash

function run_test {(
    set -e

    echo "testing $(realpath $1.vm)"
    python ../08/vm.py $1.vm > $1.asm
    cargo run --quiet --manifest-path ../../crates/assembler/Cargo.toml $1.asm > $1.hack
    sh "../../tools/CPUEmulator.sh" $1.tst
    echo ""
)}

function run_tests {(
    set -e

    run_test "./StackArithmetic/SimpleAdd/SimpleAdd"
    run_test "./StackArithmetic/StackTest/StackTest"
    run_test "./MemoryAccess/BasicTest/BasicTest"
    run_test "./MemoryAccess/StaticTest/StaticTest"
    run_test "./MemoryAccess/PointerTest/PointerTest"
)}

run_tests
exit_status=$?
if [ ${exit_status} -ne 0 ]; then
  echo "--- FAILED: a test failed ---"
  exit "${exit_status}"
else
    echo "--- PASSED: all tests passed ---"
    exit 0
fi
