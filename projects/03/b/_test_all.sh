#!/usr/bin/env bash

function run_tests {(
    set -e

    echo "testing RAM512.tst"
    sh ../../../tools/HardwareSimulator.sh RAM512.tst
    echo ""

    echo "testing RAM4K.tst"
    sh ../../../tools/HardwareSimulator.sh RAM4K.tst
    echo ""

    echo "testing RAM16K.tst"
    sh ../../../tools/HardwareSimulator.sh RAM16K.tst
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
