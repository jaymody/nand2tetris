#!/usr/bin/env bash

function run_test {(
    set -e

    echo "testing $1.asm"
    sh ../../tools/Assembler.sh $1.asm > /dev/null
    mv $1.hack $1-expected.hack
    cargo run --quiet --manifest-path ../../crates/assembler/Cargo.toml $1.asm
    mv $1.hack $1-actual.hack
    cmp $1-expected.hack $1-actual.hack
    echo ""
)}

function run_tests {(
    set -e

    run_test add/Add
    run_test max/MaxL
    run_test max/Max
    run_test rect/RectL
    run_test rect/Rect
    run_test pong/PongL
    run_test pong/Pong
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
