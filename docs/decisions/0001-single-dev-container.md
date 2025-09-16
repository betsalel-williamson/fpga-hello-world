---
inclusion: manual
---

# 0001 - Single Development Container with Toolchain Layers

## Status

Proposed

## Context

Currently, the project utilizes separate Docker development containers for each HDL toolchain (SystemVerilog, Verilog, VHDL). This approach was initially adopted to isolate dependencies and ensure specific environments for each language. However, this leads to increased build times, redundant base image layers, and a more complex management overhead due to multiple Dockerfiles and build processes. The current separation is perceived as a pre-optimization that complicates the overall build and development workflow.

## Decision

We will consolidate the separate HDL development containers into a single base Docker container. This base container will include common dependencies and `mise` for toolchain management. Specific HDL toolchains (Verilator, Icarus Verilog, GHDL, etc.) will then be installed directly into this single container. This approach prioritizes ease of management and a simpler build process for the immediate future.

## Alternatives Considered

* **Maintain separate containers**: This was the current approach. Rejected due to increased build complexity, redundancy, and perceived pre-optimization.
* **Single monolithic container with all toolchains in one layer**: This would also lead to a very large image and less clear separation of toolchain installation steps.

## Consequences

### Positive

* **Simplified Dockerfile management**: Fewer distinct Dockerfiles to maintain for core setup.
* **Improved developer experience**: A single entry point for the development environment.
* **Easier build process**: Less complexity in managing multiple Docker builds.

### Negative

* **Potentially larger image size**: Consolidating all toolchains into one image will likely result in a larger Docker image.
* **Initial refactoring effort**: Requires modifying existing Dockerfiles and build scripts.
* **Potential for conflicting installs**: While not an issue currently, installing all toolchains directly into one environment could lead to conflicts in the future. This can be addressed with virtual environments or other isolation mechanisms if it becomes a problem.

The following OSS CAD suite is not installed due to the large size. If necessary components can be installed for the CI container.

```Dockerfile
# Catch app install oss cad suite -- increases image size by 2.1GB and slows down CI
COPY scripts/download_oss_cad_suite_static.sh .
COPY scripts/install_oss_cad_suite.sh .
RUN ./download_oss_cad_suite_static.sh && \
    ./install_oss_cad_suite.sh ./oss_cad_suite_downloads/oss-cad-suite*.tgz && \
    rm -rf ./oss_cad_suite_downloads
ENV PATH="/home/fpgauser/.local/oss-cad-suite/bin:$PATH"
```

## Rationale

The decision to move to a single base container with all HDL toolchains installed directly is driven by the need to simplify the development environment and reduce immediate build overhead. For now, the benefits of a simpler build process and easier management outweigh the potential for a larger image or future toolchain conflicts, which can be addressed if and when they arise. We are not currently experiencing issues with conflicting installs, and can implement more granular isolation (e.g., using Python virtual environments or `mise`'s isolation features) if necessary in the future.

## References

* `docker/base-dev-env/Dockerfile`
* `docker/systemverilog-dev-env/Dockerfile`
* `docker/verilog-dev-env/Dockerfile`
* `docker/vhdl-dev-env/Dockerfile`
* `docker/build_all_dev_images.sh`
