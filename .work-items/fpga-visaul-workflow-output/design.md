# Design Document: Automated Visual Workflow Output Examination and Comprehensive Test Reporting

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

## 1. Objective

To establish a robust, automated system for unit testing HDL designs using VUnit and for examining visual outputs (primarily waveform diagrams) through integration with tools like Surfer. This system will ensure headless operation within Docker, provide clear indications of design issues, and generate comprehensive test reports.

## 2. Current Challenges & Lessons Learned

* **Headless Rendering:** Traditional X11-based waveform viewers often present challenges in headless Docker environments, requiring complex display server configurations. Modern web-based viewers like Surfer are expected to handle this more gracefully.
* **VCD File Location:** Managing the explicit generation and location of VCD files from various simulation tools remains crucial for seamless integration with visualization tools.
* **Fragility:** Previous attempts at visual output generation were brittle due to precise command execution and environment configuration. VUnit's robust framework and Surfer's streamlined approach aim to provide more resilient solutions.
* **Lack of Standardized Reporting:** While some individual HDL tools offer basic reporting, a unified, standardized mechanism for generating JUnit-style test reports and comprehensive code coverage reports across all three HDL toolchains (Verilog, SystemVerilog, VHDL) was lacking. VUnit addresses this by providing a consistent testing and reporting framework.

## 3. Proposed Solution

### **3.1. Core Waveform Visualization Mechanism**

We will prioritize the investigation and integration of **Surfer** or similar web-based waveform viewers for embedding interactive simulation results directly into reports or documentation. This approach offers a more streamlined and robust solution for headless environments compared to programmatic plotting with `matplotlib` for VCD files.

* **Surfer - Modern Waveform Visualization:**
  * Surfer is a modern, open-source waveform viewer that aims to provide a high-performance and user-friendly experience, especially for large waveform files.
  * We will investigate Surfer's capabilities for headless operation and automated image exports (PNG/SVG) directly from the command line or via its API, potentially offering a more streamlined approach than traditional X11-based viewers.
  * **Integration Strategy:** We will explore using Surfer's command-line interface for batch processing and image generation within CI/CD pipelines. If a Python API is available, it will be integrated into our Python-based orchestration framework for programmatic control.

* **GTKWave (as an alternative/fallback):**
  * GTKWave remains a widely used free viewer for VCD files.
  * Its headless operation via `xvfb-run` and Tcl scripting for `.sav` files will be maintained as a fallback or for specific use cases where Surfer might not be suitable.
  * We will continue to use Python wrappers for `.sav` generation to abstract raw Tcl commands.

* **Converting VCD to Other Formats:**
  * `vcd2fst`: Converts VCD to FST (compressed, faster to load).
  * `pyvcd` (Python): Allows programmatic parsing of VCDs, which might be useful for pre-processing data for Surfer or for specific analysis needs.
  * `verilator --trace` can generate VCD or FST, which can then be post-processed.

### **3.2. Comprehensive Test Reporting (JUnit & Code Coverage)**

**VUnit** will be the primary framework for generating JUnit-style test reports and code coverage reports for VHDL and Verilog/SystemVerilog designs. VUnit provides native support for these reporting formats, ensuring consistency and broad compatibility with CI/CD systems.

* **JUnit Reports:** VUnit will output test results in JUnit XML format, which is widely supported by CI/CD systems for test result visualization.
* **Code Coverage Reports:** VUnit will aim to produce code coverage reports in a standard format (e.g., Cobertura XML, LCOV) to track the thoroughness of tests.

### **3.3. HDL Unit Testing Framework (VUnit)**

**VUnit** will be integrated as the core unit testing framework for VHDL and Verilog/SystemVerilog. VUnit leverages Python for test orchestration, allowing for powerful test automation and seamless integration with Python's ecosystem for data analysis and reporting.

* **Advantages:** VUnit offers a robust, simulator-agnostic framework for writing HDL testbenches in a structured manner, providing features like test discovery, execution, and reporting. Its Python integration allows for advanced test methodologies and data processing.
* **Tcl Bridging:** If specific HDL tools or legacy components require Tcl, we will investigate mechanisms for bridging between Python (VUnit's orchestration) and Tcl (e.g., using subprocess calls or specialized libraries) to integrate existing Tcl scripts into the VUnit-based framework.

### **3.4. Workflow Integration**

* **Simulation & Output Generation:** The `Makefile` (or equivalent build system) for each HDL will be responsible for running simulations, typically invoked by VUnit, and ensuring generated VCD files, JUnit XML, and coverage reports are placed in known, consistent locations (e.g., `build/sim/`, `build/reports/`).
* **Python Orchestration Script:** A dedicated Python script (e.g., `run_tests.py`) will orchestrate the entire testing and reporting process. This script will primarily invoke VUnit and then interact with the waveform embedding module (Surfer) to process and embed simulation results.
* **Docker Integration:** The Dockerfile will ensure all necessary Python libraries (VUnit's Python package, Surfer dependencies, and other reporting libraries) and system dependencies are installed. The entrypoint or command will execute the orchestration script.
* **Integration into CI / Automation:**
  * Add VUnit commands into your simulation Makefile or CI/CD pipeline.
  * Example:

        ```makefile
        sim:
         # VUnit command to run tests and generate reports
         python run_vunit_tests.py
         # Command to process VCD and embed waveforms via Surfer
         python scripts/embed_waveforms.py sim.vcd
        ```

  * This way, every commit/run generates up-to-date test reports and embedded waveform visualizations.

### **3.5. Issue Highlighting and Analysis**

* **Waveform Analysis:** Surfer's capabilities will be leveraged for visual highlighting and analysis on waveforms (e.g., checking for expected signal values, marking anomalies). Python scripts can pre-process VCDs for specific analysis before feeding to Surfer.
* **Report Analysis:** VUnit's comprehensive JUnit and coverage reports will be parsed to identify failures, low coverage areas, and provide summary insights.

### **3.6. Artifact Management**

* All generated visual outputs (images, embedded web components), JUnit reports, and code coverage reports will be placed in dedicated `build/artifacts/` and `build/reports/` directories within the project, making them easy to locate and collect by CI/CD systems.

### **3.7. Python Libraries**

The following Python libraries will be needed for the VUnit and Surfer-based approach:

* **Required:**
  * `vunit`: The Python package for VUnit (`uv pip install vunit`)
  * `PyYAML`: Loads configuration files (`uv pip install pyyaml`)
  * `pyvcd` (Optional, for advanced VCD parsing if needed before Surfer): Allows programmatic parsing of VCDs (`uv pip install pyvcd`)
  * Surfer dependencies (to be determined during investigation, potentially a Python API or command-line wrapper).
* **Optional (depending on needs of design/designer):**
  * `numpy`: For fast numeric handling if you want to add analysis (`uv pip install numpy`)
  * `scipy`: For signal processing/FFT of simulation results (`uv pip install scipy`)
  * `pandas`: If you want CSV exports of waveforms (`uv pip install pandas`)

## 4. Key Changes

### **4.1. API Contracts**

No new external API contracts are introduced. Internal interfaces will be defined by VUnit's command-line arguments, its Python API, Surfer's command-line interface or API, report formats (JUnit XML, Cobertura/LCOV), and the structure of generated visual artifacts.

### **4.2. Data Models**

* **VCD/FST File:** Input data remains standard Value Change Dump (VCD) or Fast Signal Trace (FST) format.
* **Embedded Waveform Visualization:** Output will be interactive web components or static images generated by Surfer.
* **JUnit XML Report:** Standard XML format for test results (generated by VUnit).
* **Code Coverage Report:** Standard XML format (e.g., Cobertura) or text format (e.g., LCOV) for code coverage data (generated by VUnit).
* **Analysis Report:** A JSON or text file summarizing detected issues in waveforms and reports.

### **4.3. Component Responsibilities**

* **`Makefile` (or Build System):** Responsible for compiling HDL and invoking VUnit for simulations and report generation.
* **VUnit Test Framework (Integrated):** Core logic for test discovery, execution, and native reporting for HDL designs.
* **Python Orchestration Script (`run_tests.py`):** Invokes VUnit, processes its outputs, and interacts with the waveform embedding module (Surfer).
* **Waveform Embedding Module (Surfer Integration):** Logic for processing VCD/FST, interacting with Surfer to generate embedded visualizations, and potentially performing signal analysis.
* **`Dockerfile`:** Ensures all necessary Python dependencies (including VUnit), HDL tools, and Surfer dependencies are installed.

## 5. Alternatives Considered

* **Cocotb as Primary Test Framework:** Cocotb offers a flexible co-simulation environment. However, VUnit is chosen for its comprehensive, simulator-agnostic HDL unit testing capabilities and native reporting, which aligns better with the goal of standardized reporting across HDLs.
* **`vcdvcd` + `matplotlib` for Waveform Visualization:** This programmatic approach is replaced by the investigation of Surfer for its potential to provide interactive, web-based, and more streamlined visualization in headless environments.
* **Pure GTKWave TCL Scripting:** While functional, this approach is de-emphasized in favor of more modern and programmatic solutions like Surfer and VUnit's Python integration for headless environments.
* **Dedicated HDL Verification Languages (e.g., SystemVerilog Assertions, UVM):** These languages provide extensive verification features. However, they are considered out of scope for the initial MVP. VUnit provides a more flexible and accessible entry point for cross-HDL test framework development.

## 6. Out of Scope

* Complex timing analysis requiring dedicated EDA tools.
* Full-fledged UVM-style verification environments.
* Automatic upload of artifacts to a remote repository (this will be part of CI/CD integration, a future task).
* Support for other visual outputs (e.g., block diagrams, power reports) beyond waveforms.

## 7. Open Questions / Future Work

* Detailed specification of signal checks and anomaly detection rules for waveforms within Surfer or pre-processing scripts.
* Precise identification and integration strategy for Surfer (command-line, Python API, web component embedding).
* Integration with a CI/CD pipeline to automatically publish artifacts and reports, including embedded waveform visualizations.
* Further exploration of VUnit's advanced features for specific HDL verification needs.
