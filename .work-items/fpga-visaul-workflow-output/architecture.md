---
inclusion: manual
---

# Architecture: VUnit for HDL Unit Testing and Embedded Simulation Visualization

## 1. Introduction

This document outlines the architecture for integrating VUnit as the primary unit testing framework for VHDL and Verilog/SystemVerilog designs. It also details the investigation and integration of a tool like Surfer for embedding visual waveform outputs directly within test reports or documentation. This approach aims to provide robust validation of HDL designs and enhance observability across various environments before deployment or integration with advanced FPGA platforms like AWS EC2 F2 instances.

## 2. Business and System Context

This framework integrates into the existing FPGA development workflow, enhancing the CI/CD pipeline by providing automated, detailed feedback on HDL design correctness and quality through VUnit. The addition of embedded simulation visualization (e.g., via Surfer) will further improve rapid iteration and early detection of issues by allowing immediate visual inspection of waveforms, reducing manual verification effort and accelerating the development cycle. It interacts with HDL simulators (GHDL, QuestaSim, Riviera-PRO, VCS, etc., supported by VUnit) and leverages Python's ecosystem for orchestration, data processing, and report enhancement.

## 3. Architectural Drivers

- **Maintainability:** VUnit-based for HDL tests, leveraging standard libraries and `uv` for Python dependency management.
- **Portability:** Must run consistently across local development machines (macOS, Linux, Windows via WSL), Docker containers (ARM64, x86), and CI/CD environments.
- **Testability:** The framework itself must be easily testable.
- **Extensibility:** Designed to easily integrate new reporting formats, analysis techniques, and potentially bridge with other scripting languages (e.g., Tcl) if required by specific tools.
- **Performance:** Efficient execution of tests and report generation, especially in CI environments.
- **Observability:** Clear and actionable test reports (JUnit, code coverage from VUnit) and embedded visual outputs (waveforms).
- **Security:** Designed to run without network access to prevent data exfiltration, with integrated security scanning for Python libraries.

## 4. Architectural Decisions

- **Primary HDL Testing Framework:** VUnit for VHDL and Verilog/SystemVerilog unit testing and test orchestration.
- **Primary Orchestration Language:** Python for higher-level scripting, report processing, and integration with visualization tools.
- **Package Manager:** `uv` will be used for Python dependency management due to its speed and reliability. VUnit's own dependency management will be respected for HDL-related tools.
- **Reporting Standards:** VUnit's native reporting capabilities (e.g., JUnit XML) will be utilized. Python scripts will augment these reports for integration with visualization.
- **Waveform Visualization:** Investigation into tools like Surfer or similar web-based waveform viewers for embedding interactive simulation results directly into reports or documentation. This replaces programmatic plotting with `matplotlib` for VCD files, focusing on direct embedding of simulation output.
- **Build & Test Environments:** Support for local execution, Docker containers (cross-architecture), and CI environments.
- **Security Scanning:** Integration of tools like Trivy into container scans or other methods for security scanning of Python libraries.
- **Network Access:** The framework will be designed to operate without requiring external network access during test execution to mitigate data exfiltration risks.

## 5. Logical View

- **VUnit Test Suites:** HDL test benches organized into VUnit test suites for comprehensive unit and integration testing.
- **VUnit Test Runner:** The core VUnit framework responsible for compiling, simulating, and reporting HDL test results.
- **Python Orchestration Module:** Python scripts (`run_tests.py`) to invoke VUnit, process its outputs, and interact with visualization tools.
- **Waveform Embedding Module:** A Python module responsible for integrating with (or generating data for) Surfer or a similar tool to embed interactive waveforms.
- **Test Cases:** VHDL/SystemVerilog test benches written using VUnit's methodology.

## 6. Process View

1.  **Setup:** `uv` installs Python dependencies (offline after initial download). VUnit environment setup (simulator configuration, library compilation).
2.  **HDL Simulation & Testing:** Python orchestration script invokes VUnit, which compiles and runs HDL test suites using configured simulators.
3.  **Output Capture:** VUnit captures simulation outputs (VCD, logs, coverage data).
4.  **Waveform Embedding:** The waveform embedding module processes VCD (or other simulator-specific waveform formats) and prepares it for embedding via Surfer or a similar tool. This may involve generating static images or interactive web components.
5.  **Report Generation:** VUnit generates JUnit XML and code coverage reports. Python scripts may further process these for enhanced reporting or integration with visualization.
6.  **Security Scan:** Python libraries are scanned for vulnerabilities (e.g., via Trivy in container builds).
7.  **Artifact Collection:** All generated reports, embedded waveform outputs, and images are stored as artifacts.

## 7. Deployment View

- **Local Development (0.0.1 Release Goal):** Python environment managed by `uv`, direct execution of Python orchestration scripts that invoke VUnit. All public APIs must be clearly documented; private APIs must be protected.
- **Docker Containers:** Dedicated Docker images for each HDL toolchain, including VUnit, Python, and `uv`, built for ARM64 and x86 architectures. Tests run within these containers, with integrated security scanning.
- **CI/CD Environment:** GitHub Actions workflows (or similar) will build Docker images, run tests within containers (without network access during execution), and collect artifacts, including embedded waveform visualizations.
- **Future Integration:** The framework provides validated outputs for integration with AWS EC2 F2 instances or on-premise CI/CD infrastructure. Publication to PyPI can be considered at a later point for Python components.

## 8. Data View

- **Input:** HDL source files, VUnit test bench files, test configuration files, VCD files (from simulation), potentially simulator-specific waveform files.
- **Output:** VUnit JUnit XML reports, Cobertura/LCOV XML coverage reports, embedded interactive waveform visualizations (e.g., HTML snippets, image files), JSON/text analysis reports.
- **Intermediate:** Simulation logs, raw coverage data from HDL tools, VCD files.

## 9. Security Considerations

- **Offline Operation:** The framework will be designed to run without network access during test execution to prevent unauthorized data exfiltration.
- **Dependency Scanning:** Integrate security vulnerability scanning for Python libraries (e.g., using Trivy during Docker image builds or as a separate CI step).
- **API Protection:** All public APIs will be clearly documented. Private APIs will be protected through standard Python conventions (e.g., leading underscores) and not exposed unnecessarily.
- **Trusted Sources:** Ensure Python dependencies are sourced from trusted repositories.
- **Container Isolation:** Leverage Docker containerization for process isolation during test execution.

## 10. Operational Considerations

- **Monitoring:** CI/CD dashboards will display VUnit test results and code coverage trends. Embedded waveforms will provide immediate visual feedback.
- **Troubleshooting:** Detailed logs from VUnit, Python scripts, and HDL simulators will aid in debugging.
- **Maintenance:** Python code will adhere to best practices for readability and maintainability. `uv` will simplify dependency updates. VUnit's well-defined structure will aid HDL test maintenance.
- **Scalability:** The framework is designed to run efficiently in parallel across multiple CI/CD jobs or local environments.

## Document Organization Principles

- **Abstracted Layers**: Break documentation into focused, manageable files
- **Entry Points**: High-level overview.md as system entry point
- **Specific Concerns**: Dedicated files for architectural views (data-flow.md, security-considerations.md)
- **Cross-referencing**: Robust navigation between high-level and detailed views

## Relationship to Design Documents

This architecture document defines the overarching structure and principles for integrating VUnit and simulation visualization. Feature-level design documents (see `design.md` in this directory) for specific HDL integrations, reporting enhancements, or visualization tool integration must adhere to the architectural decisions and guidelines established here.

## Document Creation and Storage

This architecture document is stored within the `.work-items/fpga-visaul-workflow-output/` directory, providing architectural context for the visual workflow output and comprehensive test reporting feature.