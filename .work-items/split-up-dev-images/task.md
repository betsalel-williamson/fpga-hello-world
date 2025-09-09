---
inclusion: manual
---

# Task: Split FPGA Development Images

## Clear Objective

To refactor the CI pipeline by creating separate Docker images for Verilog and SystemVerilog development environments, and updating the GitHub Actions workflow to utilize these new images.

## Acceptance Criteria

- The `docker/fpga-dev-env` directory and its contents are removed.
- A new directory `docker/verilog-dev-env` exists with a `Dockerfile` containing only Verilog-specific tools (`make`, `iverilog`) and the standard non-root user setup.
- A new directory `docker/systemverilog-dev-env` exists with a `Dockerfile` containing only SystemVerilog-specific tools (`build-essential`, `verilator`) and the standard non-root user setup.
- The `.github/workflows/fpga-ci.yaml` file is updated to:
  - Define `DOCKERFILE_VERILOG_CONTEXT_PATH` and `DOCKERFILE_SYSTEMVERILOG_CONTEXT_PATH` environment variables.
  - Include new `build-and-publish-verilog-dev-image` and `build-and-publish-systemverilog-dev-image` jobs.
  - Update the `verilog-hello-world` job to use the `ghcr.io/${{ github.repository }}/${{ vars.VERILOG_IMAGE_NAME }}:latest` image and depend on `build-and-publish-verilog-dev-image`.
  - Update the `systemverilog-hello-world` job to use the `ghcr.io/${{ github.repository }}/${{ vars.SYSTEMVERILOG_IMAGE_NAME }}:latest` image and depend on `build-and-publish-systemverilog-dev-image`.
  - Remove the original `build-and-publish-docker-image` job.
- All CI jobs (Verilog, SystemVerilog, VHDL) pass successfully after the changes.

## Requirements Traceability

This task directly implements the user story "As a CI/CD Engineer Carla, I want to have separate Docker images for Verilog and SystemVerilog development environments in the CI pipeline, so that build times are reduced, image bloat is minimized, and environment isolation is improved, leading to more reliable and efficient CI/CD processes." as defined in `.work-items/split-up-dev-images/user-story.md`.

## Test Strategy

1. **Local Dockerfile Builds:** Manually build each new Docker image (`verilog-dev-env` and `systemverilog-dev-env`) locally to ensure they build successfully and contain only the expected tools.
2. **GitHub Actions Workflow Execution:** Push the changes to a branch and observe the GitHub Actions workflow execution. Verify that:
    - The new build and publish jobs for Verilog and SystemVerilog images run successfully.
    - The `verilog-hello-world` and `systemverilog-hello-world` jobs use their respective new images and pass.
    - The `vhdl-hello-world` job continues to pass without regressions.
    - The original combined Docker image build job is no longer present.
3. **Image Size Verification:** After successful builds, check the sizes of the published Docker images on GHCR to confirm that the individual images are smaller than the original combined image.
