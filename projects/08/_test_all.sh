#!/usr/bin/env bash

function run_test {(
    set -e

    echo "testing $(realpath $1)"
    cargo run --quiet --manifest-path ../../crates/vm/Cargo.toml $1 > $2.asm
    cargo run --quiet --manifest-path ../../crates/assembler/Cargo.toml $2.asm > $2.hack
    sh "../../tools/CPUEmulator.sh" $2.tst
    echo ""
)}

function run_tests {(
    set -e

    run_test "./ProgramFlow/BasicLoop/BasicLoop.vm" "./ProgramFlow/BasicLoop/BasicLoop"
    run_test "./ProgramFlow/FibonacciSeries/FibonacciSeries.vm" "./ProgramFlow/FibonacciSeries/FibonacciSeries"
    run_test "./FunctionCalls/SimpleFunction/SimpleFunction.vm" "./FunctionCalls/SimpleFunction/SimpleFunction"
    # run_test "./FunctionCalls/FibonacciElement" "./FunctionCalls/FibonacciElement/FibonacciElement"
    # run_test "./FunctionCalls/NestedCall" "./FunctionCalls/NestedCall/NestedCall"
    # run_test "./FunctionCalls/StaticsTest" "./FunctionCalls/StaticsTest/StaticsTest"
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
