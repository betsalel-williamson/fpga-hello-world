#!/bin/bash

# Script to verify SystemVerilog simulation output using Verilator

# Check for executable before simulation
echo "DEBUG: Before make simulate, checking for hello_world:"
ls -l hello_world || echo "DEBUG: hello_world not found before simulate"

# Run simulation and capture output
sim_output=$(make simulate)

# Check for executable after simulation
echo "DEBUG: After make simulate, checking for hello_world:"
ls -l hello_world || echo "DEBUG: hello_world not found after simulate"

# Check if the expected string is in the output
if echo "$sim_output" | grep -q "Hello world VHDL!"; then
    echo "INFO: Simulation output contains 'Hello world VHDL!'."
    exit 0
else
    echo "ERROR: Simulation output does NOT contain 'Hello world VHDL!'."
    echo "Simulation Output:"
    echo "$sim_output"
    exit 1
fi