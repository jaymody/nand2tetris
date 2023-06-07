#!/usr/bin/env bash

function run_tests {(
    set -e

    echo "testing Bit.tst"
    sh ../../../tools/HardwareSimulator.sh Bit.tst
    echo ""

    echo "testing Register.tst"
    sh ../../../tools/HardwareSimulator.sh Register.tst
    echo ""

    echo "testing RAM8.tst"
    sh ../../../tools/HardwareSimulator.sh RAM8.tst
    echo ""

    echo "testing RAM64.tst"
    sh ../../../tools/HardwareSimulator.sh RAM64.tst
    echo ""

    echo "testing PC.tst"
    sh ../../../tools/HardwareSimulator.sh PC.tst
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
