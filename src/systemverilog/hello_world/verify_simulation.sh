#!/bin/bash

# Script to verify SystemVerilog simulation output using Verilator

# Run simulation and capture output
sim_output=$(./obj_dir/Vhello_world)

# Check if the expected string is in the output
if echo "$sim_output" | grep -q "Hello, SystemVerilog!"; then
    echo "INFO: Simulation output contains 'Hello, SystemVerilog!'."
    exit 0
else
    echo "ERROR: Simulation output does NOT contain 'Hello, SystemVerilog!'."
    echo "Simulation Output:"
    echo "$sim_output"
    exit 1
fi