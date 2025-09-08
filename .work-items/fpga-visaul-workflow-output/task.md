### Task: Implement Automated Visual Workflow Output Examination

**Goal:** Establish a robust, automated system for generating and examining visual outputs from the FPGA development workflow, ensuring headless operation within Docker and providing clear indications of design issues.

#### Sub-tasks:

1.  **Refactor `render_waveform.py` for Robustness and Analysis:**
    *   Ensure `matplotlib.use('Agg')` is correctly set for headless operation.
    *   Implement basic signal value checks (e.g., `clk` toggling, `rst` behavior) within the script.
    *   Add visual annotations (e.g., text, colored backgrounds) to the waveform plot if issues are detected.
    *   Generate a simple text or JSON report alongside the image summarizing detected issues.

2.  **Update `Makefile` for Consistent VCD Output:**
    *   Modify the `simulate` target in `src/verilog/hello_world/Makefile` to output `hello_world.vcd` to a consistent, known location (e.g., `build/sim/hello_world.vcd`). Create the `build/sim` directory if it doesn't exist.

3.  **Create `generate_visual_output.sh` Orchestration Script:**
    *   Create a new shell script that:
        *   Verifies the existence of the VCD file at the expected location.
        *   Invokes the (refactored) `render_waveform.py` with correct paths.
        *   Handles any necessary environment variables.
        *   Ensures the output image and report are saved to a designated `build/artifacts/` directory.

4.  **Update `docker/fpga-dev-env/Dockerfile`:**
    *   Ensure all Python dependencies (`vcdvcd`, `matplotlib`) are installed.
    *   Remove `gtkwave` and `xvfb` installations, as we are moving away from GTKWave for this feature.

5.  **Integrate into CI/CD (Future Consideration):**
    *   (Out of scope for this task, but note for future) Update `.github/workflows/fpga-ci.yaml` to run `generate_visual_output.sh` and collect the generated artifacts.

6.  **Clean up Old Files:**
    *   Delete the old `render_waveform.sh`.
    *   Delete `src/verilog/hello_world/render_waveform.tcl`.
    *   (Note: `render_waveform.py` will be refactored, not deleted).

#### Definition of Done:
*   New feature user story, design, and task documents are created.
*   `render_waveform.py` is refactored to include basic analysis and visual issue highlighting.
*   `Makefile` is updated to output VCD to a consistent location.
*   `generate_visual_output.sh` is created and correctly orchestrates the rendering.
*   `Dockerfile` is updated to reflect the new Python-centric approach.
*   Old GTKWave-related files are removed.
*   The automated visual output generation runs successfully within the Docker environment, producing an image and a basic report.
