# Design Document: Automated Visual Workflow Output Examination and Comprehensive Test Reporting

## 1. Objective

To establish a robust, automated system for generating and examining visual outputs (primarily waveform diagrams) and comprehensive test reports (JUnit and code coverage) from the FPGA development workflow. This system will ensure headless operation within Docker, provide clear indications of design issues, and leverage Python as the primary language for test framework development across Verilog, SystemVerilog, and VHDL toolchains.

## 2. Current Challenges & Lessons Learned

* **Headless Rendering:** Direct use of `xvfb-run --auto-display` proved problematic in the Docker environment. Explicitly setting `DISPLAY=:99` and relying on `xvfb-run` without `--auto-display` is a more reliable approach.
* **VCD File Location:** The VCD file generation location must be explicitly managed. Simulation tools (like `vvp`) often output to the current working directory, which may not be the same as where the rendering script is invoked.
* **Fragility:** The current setup for visual output is brittle, requiring precise command execution and environment configuration.
* **Lack of Standardized Reporting:** There is no existing standardized mechanism for generating JUnit-style test reports or code coverage reports across all three HDL toolchains (Verilog, SystemVerilog, VHDL).

## 3. Proposed Solution

### **3.1. Core Waveform Rendering Mechanism**

We will prioritize a Python-based rendering approach using `vcdvcd` and `matplotlib` for VCD to image conversion. This offers greater control, easier debugging, and better integration with Python-based analysis tools. `matplotlib.use('Agg')` will be explicitly set for headless rendering.

### **3.2. Comprehensive Test Reporting (JUnit & Code Coverage)**

For each HDL toolchain (Verilog, SystemVerilog, VHDL), we will implement or integrate solutions for generating JUnit-style test reports and code coverage reports.

* **Validation & MVP Development:** We will first validate if existing tools (e.g., `verilator --xml-coverage`, `ghdl --coverage`) can produce these reports. If not, we will develop minimal viable product (MVP) tools within this repository to parse simulation logs or intermediate outputs and generate reports in standard formats (e.g., JUnit XML, Cobertura XML for coverage).
* **JUnit Reports:** The test framework will output results in JUnit XML format, which is widely supported by CI/CD systems for test result visualization.
* **Code Coverage Reports:** The test framework will aim to produce code coverage reports in a standard format (e.g., Cobertura XML, LCOV) to track the thoroughness of tests.

### **3.3. Unit Testing Framework Language (Python)**

Python will be the primary scripting language for developing the unit testing framework. Its rich ecosystem of data analysis libraries (e.g., Pandas, NumPy) makes it ideal for processing simulation outputs, analyzing waveforms, and generating reports.

* **Advantages:** Ease of development, powerful libraries for data manipulation and visualization, strong community support.
* **Tcl Bridging:** While Python is preferred, if specific HDL tools or legacy components require Tcl, we will investigate mechanisms for bridging between Python and Tcl (e.g., using subprocess calls or specialized libraries) to integrate existing Tcl scripts into the Python-based framework.

### **3.4. Workflow Integration**

* **Simulation & Output Generation:** The `Makefile` (or equivalent build system) for each HDL will be responsible for running simulations and explicitly placing generated VCD files, JUnit XML, and coverage reports in known, consistent locations (e.g., `build/sim/`, `build/reports/`).
* **Orchestration Script:** A dedicated Python script (e.g., `run_tests.py`) will orchestrate the entire testing and reporting process. This script will:
  * Invoke simulation tools.
  * Call the Python rendering script for waveforms.
  * Generate JUnit and code coverage reports.
  * Handle any necessary environment variables.
* **Docker Integration:** The Dockerfile will ensure all necessary Python libraries (`vcdvcd`, `matplotlib`, reporting libraries) and system dependencies are installed. The entrypoint or command will execute the orchestration script.

### **3.5. Issue Highlighting and Analysis**

* **Waveform Analysis:** The Python rendering script will be enhanced to perform basic analysis and visual highlighting on waveforms (e.g., checking for expected signal values, marking anomalies).
* **Report Analysis:** The orchestration script or a dedicated analysis module will parse JUnit and coverage reports to identify failures, low coverage areas, and provide summary insights.

### **3.6. Artifact Management**

* All generated visual outputs (images), JUnit reports, and code coverage reports will be placed in dedicated `build/artifacts/` and `build/reports/` directories within the project, making them easy to locate and collect by CI/CD systems.

## 4. Key Changes

### **4.1. API Contracts**

No new external API contracts are introduced. Internal interfaces will be defined by Python script command-line arguments, report formats (JUnit XML, Cobertura/LCOV), and the structure of generated visual artifacts.

### **4.2. Data Models**

* **VCD File:** Input data remains the standard Value Change Dump (VCD) format.
* **Waveform Image:** Output will be a PNG image (e.g., `hello_world_waveform.png`).
* **JUnit XML Report:** Standard XML format for test results.
* **Code Coverage Report:** Standard XML format (e.g., Cobertura) or text format (e.g., LCOV) for code coverage data.
* **Analysis Report:** A JSON or text file summarizing detected issues in waveforms and reports.

### **4.3. Component Responsibilities**

* **`Makefile` (or Build System):** Responsible for compiling HDL, running simulations, and ensuring VCD files, raw test logs, and coverage data are generated in predictable locations.
* **Python Test Framework (New):** Core logic for orchestrating simulations, parsing outputs, generating JUnit and code coverage reports, and invoking waveform rendering.
* **`render_waveform.py` (Enhanced):** Logic for parsing VCD, plotting waveforms, performing signal analysis, and adding visual annotations.
* **`Dockerfile`:** Ensures all necessary Python dependencies and HDL tools are installed.

## 5. Alternatives Considered

* **Pure GTKWave TCL Scripting:** Rejected due to fragility in headless environments.
* **Other VCD Viewers:** `vcdvcd` + `matplotlib` offers a programmatic, scriptable, and widely supported solution.
* **Dedicated HDL Verification Languages (e.g., SystemVerilog Assertions, UVM):** While powerful, these are out of scope for initial MVP. Python provides a more flexible and accessible entry point for cross-HDL test framework development.

## 6. Out of Scope

* Complex timing analysis requiring dedicated EDA tools.
* Interactive waveform viewing within the Docker environment.
* Automatic upload of artifacts to a remote repository (this will be part of CI/CD integration, a future task).
* Full-fledged UVM-style verification environments.

## 7. Open Questions / Future Work

* Detailed specification of signal checks and anomaly detection rules for waveforms.
* Precise identification and integration of JUnit and code coverage generation tools for each HDL toolchain.
* Development of MVP tools for JUnit/coverage reporting if no suitable existing tools are found.
* Integration with a CI/CD pipeline to automatically publish artifacts and reports.
* Support for other visual outputs (e.g., block diagrams, power reports).
