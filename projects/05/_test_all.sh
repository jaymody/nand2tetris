#!/usr/bin/env bash

# NOTE: the test for Memory must be run manually, and some of the Computer
# tests should also be run manually to verify the Screen/Keyboard logic

function run_tests {(
    set -e

    echo "testing CPU.tst"
    sh ../../tools/HardwareSimulator.sh CPU.tst
    echo ""

    echo "testing CPU-external.tst"
    sh ../../tools/HardwareSimulator.sh CPU-external.tst
    echo ""

    echo "testing ComputerAdd.tst"
    sh ../../tools/HardwareSimulator.sh ComputerAdd.tst
    echo ""

    echo "testing ComputerAdd-External.tst"
    sh ../../tools/HardwareSimulator.sh ComputerAdd-External.tst
    echo ""

    echo "testing ComputerMax.tst"
    sh ../../tools/HardwareSimulator.sh ComputerMax.tst
    echo ""

    echo "testing ComputerMax-external.tst"
    sh ../../tools/HardwareSimulator.sh ComputerMax-external.tst
    echo ""

    echo "testing ComputerRect.tst"
    sh ../../tools/HardwareSimulator.sh ComputerRect.tst
    echo ""

    echo "testing ComputerRect-external.tst"
    sh ../../tools/HardwareSimulator.sh ComputerRect-external.tst
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
