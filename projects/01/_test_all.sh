#!/usr/bin/env bash

function run_tests {(
    set -e

    echo "testing Not.tst"
    sh ../../tools/HardwareSimulator.sh Not.tst
    echo ""

    echo "testing And.tst"
    sh ../../tools/HardwareSimulator.sh And.tst
    echo ""

    echo "testing Or.tst"
    sh ../../tools/HardwareSimulator.sh Or.tst
    echo ""

    echo "testing Xor.ts"
    sh ../../tools/HardwareSimulator.sh Xor.tst
    echo ""

    echo "testing Mux.tst"
    sh ../../tools/HardwareSimulator.sh Mux.tst
    echo ""

    echo "testing DMux.tst"
    sh ../../tools/HardwareSimulator.sh DMux.tst
    echo ""

    echo "testing Not16.tst"
    sh ../../tools/HardwareSimulator.sh Not16.tst
    echo ""

    echo "testing And16.tst"
    sh ../../tools/HardwareSimulator.sh And16.tst
    echo ""

    echo "testing Or16.tst"
    sh ../../tools/HardwareSimulator.sh Or16.tst
    echo ""

    echo "testing Or8Way.tst"
    sh ../../tools/HardwareSimulator.sh Or8Way.tst
    echo ""

    echo "testing Mux16.tst"
    sh ../../tools/HardwareSimulator.sh Mux16.tst
    echo ""

    echo "testing DMux4Way.tst"
    sh ../../tools/HardwareSimulator.sh DMux4Way.tst
    echo ""

    echo "testing DMux8Way.tst"
    sh ../../tools/HardwareSimulator.sh DMux8Way.tst
    echo ""

    echo "testing Mux4Way16.tst"
    sh ../../tools/HardwareSimulator.sh Mux4Way16.tst
    echo ""

    echo "testing Mux8Way16.tst"
    sh ../../tools/HardwareSimulator.sh Mux8Way16.tst
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
