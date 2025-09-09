# Tasks: VHDL Hello World Example

This document outlines the technical tasks required to implement the VHDL "hello world" example, tracing back to the user story and design document.

## Task 1: Create VHDL Source File (`hello_world.vhd`)

- **Objective**: Implement a basic VHDL entity and architecture that demonstrates a simple, observable behavior (e.g., toggling an output signal or a simple counter).
- **Acceptance Criteria**:
  - The file `src/vhdl/hello_world/hello_world.vhd` exists.
  - The VHDL code is syntactically correct and adheres to VHDL-2008 standards.
  - The entity has at least a clock input and a simple output (e.g., a single bit or a small vector).
  - The architecture implements a basic sequential logic (e.g., a counter, a toggling flip-flop) that can be observed in simulation.
- **Requirements Traceability**: Directly supports the user story's goal of having a simple VHDL example and the design's `hello_world.vhd` component.
- **Test Strategy**: Initial verification will be through compilation using a VHDL compiler (e.g., GHDL) to check for syntax errors.
- **Status**: Completed

## Task 2: Create Makefile for Compilation and Simulation

- **Objective**: Develop a `Makefile` that automates the compilation of `hello_world.vhd` and its simulation using GHDL.
- **Acceptance Criteria**:
  - The file `src/vhdl/hello_world/Makefile` exists.
  - The `Makefile` includes targets for `all` (compilation), `clean` (removes generated files), and `simulate` (runs the simulation).
  - The `all` target successfully compiles `hello_world.vhd` using GHDL.
  - The `simulate` target successfully executes the compiled VHDL design and generates a VCD waveform file or prints output to the console.
- **Requirements Traceability**: Supports the design's `Makefile` component and the user story's need for environment verification.
- **Test Strategy**: Execute `make all` and `make simulate` to confirm successful compilation and simulation execution.
- **Status**: Completed

## Task 3: Create Verification Script (`verify_simulation.sh`)

- **Objective**: Write a shell script to automate the simulation process and verify the output against expected behavior.
- **Acceptance Criteria**:
  - The file `src/vhdl/hello_world/verify_simulation.sh` exists and is executable.
  - The script calls `make simulate`.
  - The script analyzes the simulation output (e.g., VCD file, console output) to confirm the expected behavior of the `hello_world.vhd` design.
  - The script prints "PASS" if the verification is successful and "FAIL" otherwise.
- **Requirements Traceability**: Directly addresses the user story's acceptance criteria for a "PASS" status and the design's `verify_simulation.sh` component.
- **Test Strategy**: Run `./verify_simulation.sh` and observe the output. It should report "PASS" if the VHDL design behaves as expected.
- **Status**: Completed

## Task 4: Create `.gitignore`

- **Objective**: Create a `.gitignore` file to prevent simulation-generated files from being committed to the repository.
- **Acceptance Criteria**:
  - The file `src/vhdl/hello_world/.gitignore` exists.
  - The `.gitignore` file includes patterns to ignore common simulation output files (e.g., `*.o`, `*.cf`, `*.vcd`, `work/`).
- **Requirements Traceability**: Adheres to good project practices and maintains a clean repository.
- **Test Strategy**: After running `make simulate`, `git status` should not show any generated simulation files as untracked or modified.
- **Status**: Completed

## Task 5: Create Docker Build and Test Script

- **Objective**: Create a shell script to build the VHDL development Docker image and verify GHDL installation within it.
- **Acceptance Criteria**:
  - The file `docker/vhdl-dev-env/build_and_test.sh` exists and is executable.
  - The script successfully builds the Docker image `vhdl-dev-env:latest`.
  - The script runs a test within the Docker container to confirm `ghdl --version` executes successfully.
  - The script reports "PASS" if the build and test are successful, and "FAIL" otherwise.
- **Requirements Traceability**: Supports the overall goal of providing a robust development environment and ensures the Docker image is functional.
- **Test Strategy**: Run `./build_and_test.sh` from the `docker/vhdl-dev-env/` directory and observe the output. It should report "PASS" if the Docker image builds and GHDL is verified.
- **Status**: Completed

## Task 6: Update `SETUP.md` with GHDL Installation Instructions

- **Objective**: Update the project's `SETUP.md` documentation to include instructions for installing GHDL via Homebrew and update the section title to be more inclusive.
- **Acceptance Criteria**:
  - The `SETUP.md` file is modified to include GHDL installation steps.
  - The section title "Verilog & SystemVerilog Development Tools" is updated to "HDL Development Tools".
  - GHDL is added to the verification steps in `SETUP.md`.
- **Requirements Traceability**: Ensures the project documentation is up-to-date and assists developers in setting up their VHDL environment.
- **Test Strategy**: Manually review `SETUP.md` to confirm the changes are present and accurate.
- **Status**: Completed

## Task 7: Integrate VHDL CI into `fpga-ci.yaml`

- **Objective**: Add a new GitHub Actions workflow job to `.github/workflows/fpga-ci.yaml` for building the VHDL development Docker image and running the VHDL "hello world" simulation and verification.
- **Acceptance Criteria**:
  - The `.github/workflows/fpga-ci.yaml` file is modified to include a new job `build-and-publish-vhdl-dev-image` that builds and pushes the VHDL Docker image to GHCR.
  - A subsequent job `vhdl-hello-world` is added that uses the newly built VHDL Docker image to run the VHDL "hello world" simulation and verification script.
  - The CI workflow correctly identifies changes in the VHDL Dockerfile context to trigger rebuilds.
- **Requirements Traceability**: Establishes continuous integration for VHDL examples, ensuring their correctness and maintainability.
- **Test Strategy**: Push changes to a branch and observe the GitHub Actions workflow run, confirming the new VHDL jobs execute successfully.
- **Status**: Completed
