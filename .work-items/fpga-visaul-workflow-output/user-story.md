# User Story: Automated Visual Workflow Output Examination and Comprehensive Test Reporting

## User Persona Definition

- **Name:** FPGA Developer
- **Description:** An FPGA developer is a software engineer specializing in FPGA development. This role is responsible for designing, simulating, and verifying Verilog code. The developer needs efficient ways to quickly assess the correctness of designs, especially when working in automated CI/CD environments where visual inspection is not always feasible.

**As an FPGA Developer,**
**I want to easily examine visual outputs (like waveform diagrams) and comprehensive test reports from the FPGA workflow in an automated fashion,**
**So that I can quickly identify and diagnose issues without manual inspection, understand the state of the design at a glance, and track test quality metrics.**

## Description

Currently, generating and viewing waveform diagrams from VCD files requires manual steps, including running specific scripts and potentially dealing with display server configurations in headless environments. This process is cumbersome and prone to errors, as demonstrated by recent attempts to integrate GTKWave rendering in a Dockerized environment.

This feature aims to automate the generation, display, and initial analysis of visual outputs from the FPGA simulation and synthesis workflows, alongside comprehensive test reporting. It should provide a streamlined mechanism to:

1. **Generate Visual Artifacts:** Automatically produce relevant visual outputs (e.g., waveform images from VCD files, potentially other diagrams like block schematics or timing reports) for all three HDL toolchains (Verilog, SystemVerilog, VHDL).
2. **Generate Comprehensive Test Reports:** Automatically generate JUnit-style test reports and code coverage reports for all three HDL toolchains.
3. **Centralized Access/Display:** Offer an easy way to access or view these generated artifacts and reports, ideally integrated into a CI/CD pipeline or a local development environment with minimal setup.
4. **Highlight Issues:** Automatically highlight or flag potential issues directly on the visual output or provide clear indicators when anomalies are detected (e.g., unexpected signal values, timing violations).
5. **Unit Testing Framework Language:** Establish Python as the preferred scripting language for developing unit testing frameworks, leveraging its data analysis capabilities. If necessary, bridging with Tcl will be considered.

## Acceptance Criteria

- **WHEN** the simulation workflow completes for any HDL (Verilog, SystemVerilog, VHDL) **THEN** the FPGA Developer **SHALL** see automatically generated waveform images from VCD files, highlighting key moments (signals, time duration).
- **WHEN** the simulation workflow completes for any HDL (Verilog, SystemVerilog, VHDL) **THEN** the FPGA Developer **SHALL** see automatically generated JUnit-style test reports.
- **WHEN** the simulation workflow completes for any HDL (Verilog, SystemVerilog, VHDL) **THEN** the FPGA Developer **SHALL** see automatically generated test code coverage reports.
- **WHEN** visual outputs and test reports are generated **THEN** the FPGA Developer **SHALL** be able to easily access them from a known location or artifact repository.
- **WHEN** the system runs in a Docker container **THEN** the FPGA Developer **SHALL** observe headless visual output generation and report generation without manual display configuration.
- **WHEN** anomalies or failures are detected in the waveform or test reports **THEN** the FPGA Developer **SHALL** see visual indications or reports highlighting these issues.
- **WHEN** the system attempts headless rendering **THEN** the FPGA Developer **SHALL** not encounter issues related to `xvfb-run --auto-display` or VCD file not found errors.

## Issues to Address (from previous attempts)

- `xvfb-run --auto-display` not recognized in the Docker environment.

- VCD file not being generated in the expected location for the rendering script.
- General fragility of the headless rendering setup.
- Lack of standardized JUnit and code coverage reporting across HDL toolchains.

## Success Metrics

- **Primary Metric:** 100% automated generation of waveform images, JUnit reports, and code coverage reports for all simulated designs within the CI/CD pipeline.

- **Secondary Metrics:**
  - Reduction in manual debugging time for waveform analysis and test result interpretation by 20%.
  - Successful headless rendering and report generation rate of 95% or higher in Dockerized environments.
  - Successful integration of Python as the primary scripting language for test frameworks.
