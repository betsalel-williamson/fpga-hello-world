# Task Document: Implement Automated Visual Workflow Output and Comprehensive Test Reporting

## 0. Resources

### FPGA Resources

* VHDL For Logic Synthesis by Andrew Rushton (PDF available online)
* The Verilog Hardware Description Language (PDF available online)
* The Design Warrior's Guide to FPGAs (PDF available online)

### AMD Resources

* AMD Forums
* AMD Tech Blogs
* Xilinx Wiki
* Xilinx GitHub

## 1. Overview

This task involves integrating VUnit as the primary unit testing framework for HDL designs and investigating tools like Surfer for automated visual waveform output. The system will generate comprehensive test reports (JUnit and code coverage) for Verilog, SystemVerilog, and VHDL simulation toolchains, designed for headless operation within Docker.

## 2. Sub-Tasks

### **2.1. Leverage VUnit for Reporting (JUnit & Code Coverage)**

*   **Objective:** Leverage VUnit's native capabilities for generating JUnit-style test reports and code coverage reports for Verilog, SystemVerilog, and VHDL.
*   **Deliverables:**
    *   Documentation of VUnit's reporting capabilities for each HDL toolchain.
    *   Configuration of VUnit to output JUnit XML and code coverage reports.
*   **Steps:**
    1.  Familiarize with VUnit's reporting features and configuration for JUnit and code coverage.
    2.  Configure VUnit test benches to generate JUnit XML reports.
    3.  Configure VUnit to generate code coverage reports in a standard format (e.g., Cobertura XML).

### **2.2. Augment VUnit Reports (if necessary)**

*   **Objective:** If VUnit's native reporting does not fully meet requirements, develop minimal tools to augment its JUnit-style test reports and code coverage reports.
*   **Deliverables:**
    *   Python scripts to process VUnit outputs and generate enhanced JUnit XML or Cobertura/LCOV XML reports (if needed).
*   **Steps:**
    1.  Identify any gaps in VUnit's native reporting for specific project needs.
    2.  Design and implement Python modules to process VUnit's raw outputs and generate augmented reports.

### **2.3. Integrate VUnit as HDL Unit Testing Framework**

*   **Objective:** Integrate VUnit as the core unit testing framework for orchestrating simulations, running tests, and collecting results across all HDL toolchains.
*   **Deliverables:**
    *   VUnit-based test runner setup.
    *   Basic VUnit test cases for each HDL (Verilog, SystemVerilog, VHDL).
*   **Steps:**
    1.  Set up a VUnit project structure within the repository.
    2.  Develop Python scripts to invoke VUnit and manage test execution for different HDL projects.
    3.  Create initial VUnit test benches for example Verilog, SystemVerilog, and VHDL designs.

### **2.4. Integrate Surfer for Waveform Visualization**

*   **Objective:** Investigate and integrate Surfer or a similar web-based waveform viewer for embedding interactive simulation results, ensuring headless operation and highlighting key moments.
*   **Deliverables:**
    *   Documentation of Surfer's integration strategy (command-line, API, web component embedding).
    *   Example embedded waveform visualizations with highlighted critical signals/timeframes.
*   **Steps:**
    1.  Research Surfer's capabilities for headless operation and embedding interactive waveforms into reports or web pages.
    2.  Develop Python scripts to process VCD/FST files and interact with Surfer (e.g., via its command-line interface or a Python API if available) to generate embedded visualizations.
    3.  Implement logic to automatically identify and mark critical events or signals for enhanced visualization within Surfer.

### **2.5. Integrate into CI/CD Workflow**

*   **Objective:** Update the `fpga-ci.yaml` to incorporate the VUnit-based test framework, report generation, and Surfer-based waveform visualization.
*   **Deliverables:**
    *   Updated `fpga-ci.yaml` with new steps for running VUnit tests, generating reports, and uploading artifacts, including embedded waveform visualizations.
    *   Successful CI/CD runs demonstrating all new outputs.
*   **Steps:**
    1.  Modify Dockerfiles to include VUnit, Python, and Surfer dependencies.
    2.  Update `fpga-ci.yaml` to call VUnit tests and the waveform embedding script.
    3.  Configure artifact uploads for VUnit JUnit XML, coverage reports, and embedded waveform visualizations.

### **2.6. Install Python Libraries**

*   **Objective:** Ensure all necessary Python libraries for VUnit and Surfer integration are installed.
*   **Deliverables:**
    *   Updated Dockerfiles to include `uv pip install` commands for required libraries.
    *   Confirmation that all Python scripts run without import errors.
*   **Steps:**
    1.  Add `uv pip install vunit` to the Dockerfiles.
    2.  Identify and add Surfer's Python dependencies (if any) or other necessary libraries to the Dockerfiles.
    3.  Ensure `uv` is used for all Python dependency management.

## 3. Definition of Done

*   VUnit-based test reports (JUnit-style and code coverage) are automatically generated for Verilog, SystemVerilog, and VHDL simulations.
*   Embedded interactive waveform visualizations (e.g., via Surfer) are automatically generated for all HDL simulations, visually highlighting key signals and time durations.
*   All generated reports and visual artifacts are accessible as CI/CD artifacts.
*   The entire process runs headlessly within the Dockerized CI/CD environment.
*   VUnit is established as the core unit testing framework for HDL designs.
*   All relevant documentation (`user-story.md`, `design.md`, `task.md`) is updated to reflect these changes.

## 4. Dependencies

*   Updated Docker images with `ghdl-gcc` (already completed).
*   Python 3.x and necessary libraries:
    *   Required: `vunit`, `PyYAML`, Surfer dependencies (to be determined during investigation).
    *   Optional: `numpy`, `scipy`, `pandas` (for advanced analysis).

## 5. Estimated Effort

*   To be determined after initial research and validation (Sub-Task 2.1).