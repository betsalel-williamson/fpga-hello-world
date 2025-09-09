---
inclusion: manual
---

# Design: Split FPGA Development Images

## 1. Objective

To refactor the CI pipeline by separating the Verilog and SystemVerilog development environments into distinct Docker images, thereby reducing image bloat, enhancing build efficiency, and ensuring environment isolation, consistent with the approach taken for VHDL.

## 2. Technical Design

The current `fpga-dev-env` Docker image, which serves both Verilog and SystemVerilog, will be replaced by two new, specialized images: `verilog-dev-env` and `systemverilog-dev-env`. Each new image will contain only the tools necessary for its respective hardware description language (HDL). The GitHub Actions workflow `fpga-ci.yaml` will be updated to build, publish, and utilize these new images in their dedicated test jobs. This design aligns with the principle of single responsibility and loose coupling by isolating toolchains.

## 3. Key Changes

### 3.1. API Contracts

Not applicable, as this change primarily affects internal CI infrastructure and does not expose new APIs.

### 3.2. Data Models

Not applicable, as this change does not involve data storage or schemas.

### 3.3. Component Responsibilities

- **`docker/fpga-dev-env` (Removed):** The monolithic Dockerfile and its associated directory will be eliminated.
- **`docker/verilog-dev-env/Dockerfile` (New):** This Dockerfile will be responsible for building an image containing `make` and `iverilog` for Verilog simulation. It will include the standard non-root user setup.
- **`docker/systemverilog-dev-env/Dockerfile` (New):** This Dockerfile will be responsible for building an image containing `build-essential` and `verilator` for SystemVerilog simulation. It will include the standard non-root user setup.
- **`.github/workflows/fpga-ci.yaml` (Modified):**
  - New environment variables will be introduced for `DOCKERFILE_VERILOG_CONTEXT_PATH` and `DOCKERFILE_SYSTEMVERILOG_CONTEXT_PATH`.
  - Two new jobs, `build-and-publish-verilog-dev-image` and `build-and-publish-systemverilog-dev-image`, will be added to handle the building and publishing of the respective Docker images to GHCR.
  - The existing `verilog-hello-world` job will be updated to use the `ghcr.io/${{ github.repository }}/${{ vars.VERILOG_IMAGE_NAME }}:latest` image and depend on `build-and-publish-verilog-dev-image`.
  - The existing `systemverilog-hello-world` job will be updated to use the `ghcr.io/${{ github.repository }}/${{ vars.SYSTEMVERILOG_IMAGE_NAME }}:latest` image and depend on `build-and-publish-systemverilog-dev-image`.
  - The original `build-and-publish-docker-image` job will be removed.

## 4. Alternatives Considered

- **Keeping a single image with conditional tool installation:** This was rejected because it would still lead to a larger base image and potential for unintended dependencies or conflicts, contradicting the goal of reducing bloat and ensuring isolation.
- **Using a multi-stage build within a single Dockerfile for different targets:** While this could create smaller final images, it would still involve a single, more complex Dockerfile to maintain, and the CI workflow would still need to manage multiple build targets from that single file, which is less clear than separate Dockerfiles.

## 5. Out of Scope

- Changes to the VHDL Docker image or its CI workflow.
- Optimization of the `make` commands within the `src` directories.
- Introduction of new HDL designs or test benches.
