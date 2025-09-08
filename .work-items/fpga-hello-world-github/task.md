---
inclusion: manual
---

# Task: FPGA Hello World GitHub CI Build Implementation

## Objective

Implement the local development environment setup, the "Hello World" FPGA design, and the GitHub CI workflow for building the Docker image and automating the AFI build and simulation process. This establishes the foundational, reproducible build and verification pipeline for FPGA designs.

## Requirements Traceability

-   User Story: `user-story.md`
-   Design: `design.md`

## Sequential Steps (Red-Green-Refactor)

### 1. Setup Local Development Environment

-   **Objective:** Install and configure all necessary local development tools for FPGA design.
-   **Acceptance Criteria:**
    -   Git is installed.
    -   A Verilog linter/simulator (e.g., Icarus Verilog) is installed and functional.
-   **Test Strategy:** Execute `git --version` and a simple `iverilog` command to verify installations and basic functionality.

### 2. Create Minimal HDL "Hello World" Design

-   **Objective:** Develop a simple, synthesizable Verilog module that represents a basic "Hello World" equivalent (e.g., a register that can be written to and read from, or a simple counter).
-   **Acceptance Criteria:**
    -   A Verilog file (`hello_world.v`) is created with a basic, synthesizable design. [x]
    -   A `Makefile` is created to automate build, simulate, and verify. [x]
    -   A `verify_simulation.sh` script is created to verify simulation output. [x]
    -   The design passes Verilog linting/syntax checks. [x]
-   **Test Strategy:** Run `make -C src/verilog/hello_world test` to ensure no syntax errors, successful compilation, simulation, and verification of output. [x]

### 3. Create and Publish FPGA Development Environment Docker Image (CI Workflow)

-   **Objective:** Create a Dockerfile to build a specialized image containing all necessary FPGA development tools and dependencies, and integrate its build and publish into a dedicated CI workflow.
-   **Acceptance Criteria:**
    -   A `Dockerfile` is created in `docker/fpga-dev-env/Dockerfile`. [x]
    -   A `.dockerignore` file is created for the Docker build context.
    -   The Dockerfile successfully builds into an image locally.
    -   The image contains `iverilog` and other required tools.
    -   A dedicated CI workflow (`.github/workflows/fpga-ci.yaml`) is created to build and publish this Docker image to GHCR. [x]
-   **Test Strategy:** Run `docker build -t fpga-dev-env ./docker/fpga-dev-env` and then `docker run fpga-dev-env iverilog -V` to verify the image builds and contains the necessary tools. Observe the `fpga-ci.yaml` workflow for successful Docker image build and publish.

### 4. Automate AFI Build and Simulation Process (CI/CD - Build Stage)

-   **Objective:** Set up a CI/CD pipeline to automatically trigger the AWS FPGA Development Kit (AFDK) build and simulation process upon changes to the HDL design, utilizing the pre-built and published FPGA Development Environment Docker Image.
-   **Acceptance Criteria:**
    -   The CI workflow (`.github/workflows/fpga-ci.yaml`) is updated to depend on the Docker image build workflow and uses the published FPGA Development Environment Docker Image for the build and simulate steps. [x]
    -   The pipeline successfully triggers on code push, pulls the HDL, and initiates the AFDK build and simulation process (simulated by `iverilog` build/simulate) within the Docker container. [x]
    -   A placeholder AFI is generated (or the build process completes without errors, even if the AFI is not yet fully functional). [x]
    -   The `hello_world.vvp` and `hello_world.vcd` files are uploaded as workflow artifacts. [x]
-   **Test Strategy:** Push a minor change to `hello_world.v`, observe the `fpga-ci.yaml` workflow execution, and verify that the `make test` command completes successfully using the Docker image, and that the simulation artifacts are available for download.

### 5. Create and Update Project Documentation

-   **Objective:** Create a `README.md` file and update it to reflect the project's purpose, setup instructions, and CI/CD status.
-   **Acceptance Criteria:**
    -   A `README.md` file is created at the project root.
    -   The `README.md` includes a project title, a brief description, setup instructions for local development, and a badge indicating the status of the Verilog CI workflow.
    -   A `LICENSE` file (MIT) is present at the project root. [x]
-   **Test Strategy:** Verify the presence and content of `README.md` and `LICENSE` files.
