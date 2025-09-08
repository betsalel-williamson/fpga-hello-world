#!/bin/bash

# Script to verify Verilog simulation output

# Check for .vvp file
if [ -f "hello_world.vvp" ]; then
    echo "INFO: hello_world.vvp found."
else
    echo "ERROR: hello_world.vvp not found!"
    exit 1
fi

# Check for .vcd file
if [ -f "hello_world.vcd" ]; then
    echo "INFO: hello_world.vcd found."
else
    echo "ERROR: hello_world.vcd not found!"
    exit 1
fi

echo "INFO: Simulation output verification successful."
exit 0
