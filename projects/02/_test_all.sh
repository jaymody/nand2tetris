#!/usr/bin/env bash

function run_tests {(
    set -e

    echo "testing HalfAdder.tst"
    sh ../../tools/HardwareSimulator.sh HalfAdder.tst
    echo ""

    echo "testing FullAdder.tst"
    sh ../../tools/HardwareSimulator.sh FullAdder.tst
    echo ""

    echo "testing Add16.tst"
    sh ../../tools/HardwareSimulator.sh Add16.tst
    echo ""

    echo "testing Inc16.tst"
    sh ../../tools/HardwareSimulator.sh Inc16.tst
    echo ""

    echo "testing ALU-nostat.tst"
    sh ../../tools/HardwareSimulator.sh ALU-nostat.tst
    echo ""

    echo "testing ALU.tst"
    sh ../../tools/HardwareSimulator.sh ALU.tst
    echo ""
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
