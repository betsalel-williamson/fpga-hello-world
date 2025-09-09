---
inclusion: manual
---

# Task: Implement SystemVerilog Hello World Example

## Clear Objective

Implement a basic "Hello World" example in SystemVerilog, including the SystemVerilog source file, a Makefile for compilation and simulation using Verilator, and a verification script to check the output. Additionally, update the Docker development environment and the CI pipeline to support and execute this example.

## Acceptance Criteria

- A new directory `src/systemverilog/hello_world/` exists relative to the project root.
- The file `src/systemverilog/hello_world/hello_world.sv` exists relative to the project root and contains a SystemVerilog module that prints "Hello, SystemVerilog!".
- The file `src/systemverilog/hello_world/Makefile` exists relative to the project root and correctly compiles `hello_world.sv` using `verilator --binary -j 0 -Wall hello_world.sv` and simulates it by executing `./obj_dir/Vhello_world`.
- The file `src/systemverilog/hello_world/verify_simulation.sh` exists relative to the project root, is executable, and successfully verifies that the simulation output contains "Hello, SystemVerilog!".
- Running `make test` in the `src/systemverilog/hello_world` directory successfully builds, simulates, and verifies the example.
- The `docker/fpga-dev-env/Dockerfile` is updated to include the installation of Verilator.
- The GitHub Actions workflow `.github/workflows/fpga-ci.yaml` is updated with a new job to build and test the SystemVerilog "hello-world" example in parallel with existing jobs.

## Requirements Traceability

This task directly implements the user story "SystemVerilog Hello World Example" and addresses its acceptance criteria.

## Test Strategy

The `verify_simulation.sh` script is used to automate the verification of the simulation output. The `Makefile` integrates the build, simulate, and verify steps into a `test` target, using Verilator for the simulation. The Verilator command `verilator --binary -j 0 -Wall hello_world.sv` was used to generate the executable, which is then run directly.

For more details on Verilator binary execution, refer to the [Verilator documentation](https://veripool.org/guide/latest/example_binary.html#example-create-binary-execution).