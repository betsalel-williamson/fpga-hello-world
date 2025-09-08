---
inclusion: manual
---

# Design: FPGA Hello World GitHub CI Build

## 1. Objective

To define the technical approach for developing a basic "Hello World" FPGA example, establishing a baseline for understanding the local FPGA development workflow, and automating the build and simulation process within a GitHub CI environment. This ensures a robust and reproducible process for generating a synthesizable FPGA design and verifying its functionality through simulation.

## 2. Technical Design

The "Hello World" example will involve a simple FPGA design (e.g., blinking an LED or a basic counter) implemented using a hardware description language (HDL) like Verilog or VHDL. This design will be synthesized, placed, and routed to generate a custom Amazon FPGA Image (AFI) *placeholder* (the actual AFI generation will be part of the AWS deployment feature). The focus here is on the local development and CI build/simulation.

To streamline the CI process and ensure a consistent development environment, a specialized Docker image will be created. This image will pre-install all necessary FPGA development tools (e.g., Icarus Verilog, AWS FPGA Development Kit) and dependencies, eliminating the need for on-the-fly installations within the CI pipeline.

The process will involve:
-   **HDL Design:** A minimal "Hello World" equivalent (e.g., a simple register that can be written to and read from, or a counter).
-   **FPGA Development Environment Image:** A pre-built Docker image containing all required FPGA development tools.
-   **AWS FPGA Development Kit (AFDK):** Utilizing the AFDK for synthesis, place, and route to generate the AFI *placeholder* and run simulations, executed within the specialized Docker image.
-   **CI Workflow:** An automated pipeline (e.g., GitHub Actions) triggered by Git commits to build the AFI *placeholder* (using the specialized Docker image) and run simulations.

## 3. Key Changes

### 3.1. API Contracts

N/A for this initial "Hello World" example.

### 3.2. Data Models

N/A for this initial "Hello World" example.

### 3.3. Component Responsibilities

-   **FPGA Design (HDL):** Implements the core "Hello World" logic.
-   **FPGA Development Environment Image:** Provides a consistent and pre-configured environment for FPGA tool execution.
-   **AFDK Toolchain:** Compiles the HDL into an AFI *placeholder* and runs simulations, executed within the Docker image.
-   **CI Workflow:** Automates the build and simulation process based on Git commits, utilizing the FPGA Development Environment Image.

## 4. Alternatives Considered

-   **Local FPGA Development Board:** Considered for initial learning, but the focus here is on establishing a cloud-ready CI build process.
-   **On-the-fly Tool Installation in CI:** Rejected in favor of a pre-built Docker image to reduce CI pipeline execution time, improve build consistency, and simplify workflow definitions.
-   **Different HDLs/Frameworks:** While other HDLs (VHDL) or high-level synthesis (HLS) frameworks exist, Verilog will be used for simplicity and broad compatibility for the initial "Hello World".

## 5. Out of Scope

-   Deployment to AWS (covered by `fpga-hello-world-aws`).
-   Complex FPGA designs beyond "Hello World" functionality.
-   Optimization for performance or resource utilization beyond basic functionality.
-   Detailed power analysis.
-   Integration with other AWS services beyond EC2 F1.
-   Yolo 4 Tiny or Mojo projects.
-   Additional examples using other HDLs or high-level synthesis (HLS) frameworks, or targeting different FPGA platforms.
