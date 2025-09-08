### Design Document: Automated Visual Workflow Output Examination

#### 1. Objective
To establish a robust, automated system for generating and examining visual outputs (primarily waveform diagrams) from the FPGA development workflow, ensuring headless operation within Docker and providing clear indications of design issues.

#### 2. Current Challenges & Lessons Learned
*   **Headless Rendering:** Direct use of `xvfb-run --auto-display` proved problematic in the Docker environment. Explicitly setting `DISPLAY=:99` and relying on `xvfb-run` without `--auto-display` is a more reliable approach.
*   **VCD File Location:** The VCD file generation location must be explicitly managed. Simulation tools (like `vvp`) often output to the current working directory, which may not be the same as where the rendering script is invoked.
*   **Fragility:** The current setup is brittle, requiring precise command execution and environment configuration.

#### 3. Proposed Solution

**3.1. Core Rendering Mechanism**

Instead of relying solely on GTKWave's TCL scripting, which can be finicky in headless environments, we will prioritize a Python-based rendering approach using `vcdvcd` and `matplotlib`. This offers greater control, easier debugging, and better integration with Python-based analysis tools. **Consideration will also be given to `fliplot` (https://github.com/raczben/fliplot) as an alternative, especially if it offers more streamlined headless rendering or advanced waveform visualization features.**

*   **Primary Tool:** `render_waveform.py` (or an enhanced version of it) will be the primary tool for VCD to image conversion.
*   **Headless Configuration:** `matplotlib.use('Agg')` will be explicitly set at the beginning of the Python script to ensure headless rendering without X server dependencies.

**3.2. Workflow Integration**

*   **Simulation & VCD Generation:** The `Makefile` (or equivalent build system) will be responsible for running the Verilog simulation and explicitly placing the generated VCD file in a known, consistent location (e.g., `build/sim/hello_world.vcd`).
*   **Rendering Script Invocation:** A dedicated shell script (e.g., `generate_visual_output.sh`) will orchestrate the rendering process. This script will:
    *   Verify the existence of the VCD file.
    *   Invoke the Python rendering script with the correct input and output paths.
    *   Handle any necessary environment variables (e.g., `PYTHONPATH`).
*   **Docker Integration:** The Dockerfile will ensure all necessary Python libraries (`vcdvcd`, `matplotlib`, and potentially `fliplot`) and system dependencies are installed. The entrypoint or command will execute `generate_visual_output.sh`.

**3.3. Issue Highlighting and Analysis**

This is a critical new component. The Python rendering script will be enhanced to perform basic analysis and visual highlighting.

*   **Signal Value Checks:** Implement logic within `render_waveform.py` to check for expected signal values at specific timestamps (e.g., `rst` should be high then low, `clk` should toggle). If deviations are found, visually mark them on the waveform (e.g., red background for a time range, text annotations).
*   **Timing Violation Indicators (Future):** While complex timing analysis is beyond the scope of initial VCD rendering, the framework should allow for future integration of simple timing checks (e.g., checking if a signal changes within a certain clock cycle) and visually flagging these.
*   **Output Metadata:** The rendering script can generate a small JSON or text file alongside the image, summarizing any detected issues, their timestamps, and severity.

**3.4. Artifact Management**

*   All generated visual outputs (images, analysis reports) will be placed in a dedicated `build/artifacts/` directory within the project, making them easy to locate and collect by CI/CD systems.

#### 4. Key Changes

**4.1. API Contracts**
No new external API contracts are introduced with this feature. Internal interfaces will be defined by the Python script's command-line arguments and the format of its output report.

**4.2. Data Models**
*   **VCD File:** Input data remains the standard Value Change Dump (VCD) format.
*   **Waveform Image:** Output will be a PNG image (e.g., `hello_world_waveform.png`).
*   **Analysis Report:** A new JSON or text file (e.g., `hello_world_analysis.json`) will be generated, containing structured information about detected issues (signal name, timestamp, expected value, actual value, severity, description).

**4.3. Component Responsibilities**
*   **`Makefile` (or Build System):** Responsible for compiling Verilog, running simulations, and ensuring VCD files are generated in a predictable location (`build/sim/`).
*   **`render_waveform.py` (Enhanced):** Core logic for parsing VCD, plotting waveforms, performing signal analysis, adding visual annotations for issues, and generating the analysis report.
*   **`generate_visual_output.sh` (New):** Orchestration script to invoke `render_waveform.py` with correct paths and manage output artifacts (`build/artifacts/`).
*   **`Dockerfile`:** Ensures all necessary Python dependencies are installed and removes GTKWave/Xvfb related packages.

#### 5. Alternatives Considered
*   **Pure GTKWave TCL Scripting:** While powerful, its reliance on Xvfb and specific GTKWave versions makes it less portable and harder to debug in a fully headless, automated environment compared to a Python-based approach. The `--auto-display` issue highlights this fragility.
*   **Other VCD Viewers:** Many VCD viewers exist, but `vcdvcd` + `matplotlib` offers a programmatic, scriptable, and widely supported solution for headless rendering and custom analysis.
*   **Fliplot (https://github.com/raczben/fliplot):** A Python library specifically designed for plotting digital waveforms. It could offer a more specialized and potentially optimized solution for waveform visualization compared to general-purpose `matplotlib`. Its suitability for headless environments and ease of integration with existing analysis logic would need to be evaluated.

#### 6. Out of Scope
*   Complex timing analysis requiring dedicated EDA tools.
*   Interactive waveform viewing within the Docker environment.
*   Automatic upload of artifacts to a remote repository (this will be part of CI/CD integration, a future task).
*   Support for visual outputs beyond waveform diagrams in the initial implementation.

#### 7. Open Questions / Future Work
*   Detailed specification of signal checks and anomaly detection rules.
*   Integration with a CI/CD pipeline to automatically publish artifacts.
*   Support for other visual outputs (e.g., block diagrams, power reports).