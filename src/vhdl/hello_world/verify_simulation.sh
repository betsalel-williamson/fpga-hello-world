#!/bin/bash

# Script to verify SystemVerilog simulation output using Verilator

# Run simulation and capture output
sim_output=$(mise run simulate)

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