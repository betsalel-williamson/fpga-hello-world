---
inclusion: manual
---

# Architecture: Python Unit Testing Framework for HDL

## 1. Introduction

This document outlines the architecture for a Python-based unit testing framework designed to support Verilog, SystemVerilog, and VHDL simulation toolchains. Its primary purpose is to automate the generation of comprehensive test reports (JUnit, code coverage) and visual waveform outputs, providing robust validation of HDL designs across various environments before deployment or integration with advanced FPGA platforms like AWS EC2 F2 instances.

## 2. Business and System Context

This framework integrates into the existing FPGA development workflow, enhancing the CI/CD pipeline by providing automated, detailed feedback on HDL design correctness and quality. It supports rapid iteration and early detection of issues, reducing manual verification effort and accelerating the development cycle. It interacts with HDL simulators (Icarus Verilog, Verilator, GHDL) and leverages Python's ecosystem for data processing and reporting.

## 3. Architectural Drivers

- **Maintainability:** Python-based, leveraging standard libraries and `uv` for dependency management.
- **Portability:** Must run consistently across local development machines (macOS, Linux, Windows via WSL), Docker containers (ARM64, x86), and CI/CD environments.
- **Testability:** The framework itself must be easily testable.
- **Extensibility:** Designed to easily integrate new reporting formats, analysis techniques, and potentially bridge with other scripting languages (e.g., Tcl) if required by specific tools.
- **Performance:** Efficient execution of tests and report generation, especially in CI environments.
- **Observability:** Clear and actionable test reports (JUnit, code coverage) and visual outputs (waveforms).
- **Security:** Designed to run without network access to prevent data exfiltration, with integrated security scanning for Python libraries.

## 4. Architectural Decisions

- **Primary Language:** Python for test orchestration, data analysis, and report generation.
- **Package Manager:** `uv` will be used for Python dependency management due to its speed and reliability.
- **Reporting Standards:** JUnit XML for test results and Cobertura/LCOV XML for code coverage to ensure broad compatibility with CI/CD platforms.
- **Waveform Visualization:** `vcdvcd` for VCD parsing and `matplotlib` (with `Agg` backend for headless rendering) for programmatic waveform generation from VCD files. Acknowledgment of potential limitations with VHDL-specific types in standard VCD and the need for careful VCD generation from VHDL simulators. Further research into VHDL-specific waveform formats and rendering will be conducted if standard VCD proves insufficient for VHDL.
- **Build & Test Environments:** Support for local execution, Docker containers (cross-architecture), and CI environments.
- **Security Scanning:** Integration of tools like Trivy into container scans or other methods for security scanning of Python libraries.
- **Network Access:** The framework will be designed to operate without requiring external network access during test execution to mitigate data exfiltration risks.

## 5. Logical View

- **Test Runner Module:** Central Python script (`run_tests.py`) orchestrating the entire test process.
- **HDL Interface Modules:** Python modules responsible for invoking specific HDL simulators (Icarus Verilog, Verilator, GHDL) and capturing their outputs.
- **Report Generation Modules:** Python modules for parsing simulation outputs/logs and generating JUnit XML and code coverage reports.
- **Waveform Visualization Module:** Python module (`render_waveform.py`) for VCD parsing, plotting, and annotation, with consideration for handling different waveform formats.
- **Test Cases:** Python-based test definitions for each HDL design.

## 6. Process View

1. **Setup:** `uv` installs Python dependencies (offline after initial download).
2. **Simulation:** Test runner invokes HDL simulator via interface modules.
3. **Output Capture:** Simulation outputs (VCD, logs, coverage data, potentially VHDL-specific waveform files) are captured.
4. **Waveform Generation:** Waveform visualization module processes VCD (and potentially other formats) to generate images, with emphasis on many signals and snapshotting key moments.
5. **Report Generation:** Report generation modules process logs/coverage data to create JUnit and code coverage XML.
6. **Security Scan:** Python libraries are scanned for vulnerabilities (e.g., via Trivy in container builds).
7. **Artifact Collection:** All generated reports and images are stored as artifacts.

## 7. Deployment View

- **Local Development (0.0.1 Release Goal):** Python environment managed by `uv`, direct execution of `run_tests.py`. All public APIs must be clearly documented; private APIs must be protected.
- **Docker Containers:** Dedicated Docker images for each HDL toolchain, including Python and `uv`, built for ARM64 and x86 architectures. Tests run within these containers, with integrated security scanning.
- **CI/CD Environment:** GitHub Actions workflows (or similar) will build Docker images, run tests within containers (without network access during execution), and collect artifacts.
- **Future Integration:** The framework provides validated outputs for integration with AWS EC2 F2 instances or on-premise CI/CD infrastructure. Publication to PyPI can be considered at a later point.

## 8. Data View

- **Input:** HDL source files, test configuration files, VCD files (from simulation), potentially VHDL-specific waveform files.
- **Output:** JUnit XML reports, Cobertura/LCOV XML coverage reports, PNG waveform images, JSON/text analysis reports.
- **Intermediate:** Simulation logs, raw coverage data from HDL tools.

## 9. Security Considerations

- **Offline Operation:** The framework will be designed to run without network access during test execution to prevent unauthorized data exfiltration.
- **Dependency Scanning:** Integrate security vulnerability scanning for Python libraries (e.g., using Trivy during Docker image builds or as a separate CI step).
- **API Protection:** All public APIs will be clearly documented. Private APIs will be protected through standard Python conventions (e.g., leading underscores) and not exposed unnecessarily.
- **Trusted Sources:** Ensure Python dependencies are sourced from trusted repositories.
- **Container Isolation:** Leverage Docker containerization for process isolation during test execution.

## 10. Operational Considerations

- **Monitoring:** CI/CD dashboards will display JUnit test results and code coverage trends.
- **Troubleshooting:** Detailed logs from Python scripts and HDL simulators will aid in debugging.
- **Maintenance:** Python code will adhere to best practices for readability and maintainability. `uv` will simplify dependency updates.
- **Scalability:** The framework is designed to run efficiently in parallel across multiple CI/CD jobs or local environments.

## Document Organization Principles

- **Abstracted Layers**: Break documentation into focused, manageable files
- **Entry Points**: High-level overview.md as system entry point
- **Specific Concerns**: Dedicated files for architectural views (data-flow.md, security-considerations.md)
- **Cross-referencing**: Robust navigation between high-level and detailed views

## Relationship to Design Documents

This architecture document defines the overarching structure and principles for the Python unit testing framework. Feature-level design documents (see `design.md` in this directory) for specific HDL integrations or reporting enhancements must adhere to the architectural decisions and guidelines established here.

## Document Creation and Storage

This architecture document is stored within the `.work-items/fpga-visaul-workflow-output/` directory, providing architectural context for the visual workflow output and comprehensive test reporting feature.
