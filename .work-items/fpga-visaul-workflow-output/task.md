# Task Document: Implement Automated Visual Workflow Output and Comprehensive Test Reporting

## 1. Overview

This task involves implementing an automated system for generating visual waveform outputs, JUnit-style test reports, and code coverage reports for Verilog, SystemVerilog, and VHDL simulation toolchains. The system will be designed for headless operation within Docker and will leverage Python as the primary language for test framework development.

## 2. Sub-Tasks

### **2.1. Research and Validate Existing Reporting Tools (JUnit & Code Coverage)**

* **Objective:** Determine if existing tools for Verilog, SystemVerilog, and VHDL can generate JUnit-style test reports and code coverage reports.
* **Deliverables:**
  * Documentation of findings for each HDL toolchain (tool name, command, output format).
  * Identification of gaps where MVP tools will be required.
* **Steps:**
    1. For Verilog (Icarus Verilog/Verilator): Research JUnit and code coverage generation capabilities.
    2. For SystemVerilog (Verilator): Research JUnit and code coverage generation capabilities (e.g., `verilator --xml-coverage`).
    3. For VHDL (GHDL): Research JUnit and code coverage generation capabilities (e.g., `ghdl --coverage`).

### **2.2. Develop MVP Reporting Tools (if necessary)**

* **Objective:** Create minimal viable product (MVP) tools to generate JUnit-style test reports and code coverage reports for toolchains lacking native support.
* **Deliverables:**
  * Python scripts to parse simulation logs/outputs and generate JUnit XML reports.
  * Python scripts to parse coverage data and generate Cobertura/LCOV XML reports.
* **Steps:**
    1. Design a generic Python module for parsing simulation results and generating JUnit XML.
    2. Design a generic Python module for parsing coverage data and generating Cobertura/LCOV XML.
    3. Implement specific parsers/adapters for each HDL toolchain as needed.

### **2.3. Implement Python-based Unit Testing Framework**

* **Objective:** Establish a Python-based framework for orchestrating simulations, running tests, and collecting results across all HDL toolchains.
* **Deliverables:**
  * Core Python test runner script (`run_tests.py`).
  * Integration points for invoking HDL simulators.
  * Basic test cases for each HDL (Verilog, SystemVerilog, VHDL) using the new framework.
* **Steps:**
    1. Set up a Python project structure for the test framework.
    2. Develop `run_tests.py` to execute simulation commands for each HDL.
    3. Integrate the JUnit and code coverage reporting tools/MVPs into `run_tests.py`.

### **2.4. Enhance Waveform Visualization**

* **Objective:** Improve the existing waveform visualization to highlight key moments (signals, time duration) and ensure headless operation.
* **Deliverables:**
  * Updated `render_waveform.py` script capable of advanced annotations.
  * Example waveform images with highlighted critical signals/timeframes.
* **Steps:**
    1. Modify `render_waveform.py` to accept parameters for signal highlighting and time duration annotations.
    2. Implement logic to automatically identify and mark critical events (e.g., reset assertion, data valid signals).
    3. Ensure `matplotlib.use('Agg')` is correctly configured for headless rendering.

### **2.5. Integrate into CI/CD Workflow**

* **Objective:** Update the `fpga-ci.yaml` to incorporate the new Python-based test framework, report generation, and waveform visualization.
* **Deliverables:**
  * Updated `fpga-ci.yaml` with new steps for running Python tests, generating reports, and uploading artifacts.
  * Successful CI/CD runs demonstrating all new outputs.
* **Steps:**
    1. Modify Dockerfiles to include Python and necessary libraries.
    2. Update `fpga-ci.yaml` to call `run_tests.py`.
    3. Configure artifact uploads for JUnit XML, coverage reports, and waveform images.

## 3. Definition of Done

* JUnit-style test reports are automatically generated for Verilog, SystemVerilog, and VHDL simulations.
* Test code coverage reports are automatically generated for Verilog, SystemVerilog, and VHDL simulations.
* Waveform images are automatically generated for all HDL simulations, visually highlighting key signals and time durations.
* All generated reports and visual artifacts are accessible as CI/CD artifacts.
* The entire process runs headlessly within the Dockerized CI/CD environment.
* Python is established as the primary scripting language for the unit testing framework.
* All relevant documentation (`user-story.md`, `design.md`, `task.md`) is updated to reflect these changes.

## 4. Dependencies

* Updated Docker images with `ghdl-gcc` (already completed).
* Python 3.x and necessary libraries (`vcdvcd`, `matplotlib`, XML parsing libraries).

## 5. Estimated Effort

* To be determined after initial research and validation (Sub-Task 2.1).
