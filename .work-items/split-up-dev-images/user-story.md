---
inclusion: manual
---

# User Story: Split FPGA Development Images

## User Persona Definition

- **Name:** CI/CD Engineer Carla
- **Description:** Carla is responsible for maintaining and optimizing the continuous integration and deployment pipelines. She aims to ensure efficient, reliable, and cost-effective builds and tests. Her pain points include slow build times and large, monolithic Docker images that are difficult to maintain and debug, leading to unnecessary resource consumption and potential environment conflicts.

## User Story Format

- **As a** CI/CD Engineer Carla
- **I want to** have separate Docker images for Verilog and SystemVerilog development environments in the CI pipeline
- **so that** build times are reduced, image bloat is minimized, and environment isolation is improved, leading to more reliable and efficient CI/CD processes.

## Acceptance Criteria Requirements

- WHEN a Verilog CI job runs THEN it SHALL use a Docker image containing only Verilog-specific tools.
- WHEN a SystemVerilog CI job runs THEN it SHALL use a Docker image containing only SystemVerilog-specific tools.
- WHEN the CI pipeline is updated THEN the overall Docker image sizes SHALL be reduced compared to the monolithic image.
- WHEN a change is made to Verilog tools THEN the SystemVerilog CI environment SHALL remain unaffected.

## Value Proposition

This change will clearly articulate business or user value by:

- Reducing CI pipeline execution times, leading to faster feedback loops for developers.
- Lowering resource consumption (storage and bandwidth) associated with Docker images.
- Increasing the stability and reliability of CI jobs by eliminating potential tool conflicts between different HDL environments.

## Success Metrics

- that changes to one tool chain doesn't affect other toolchains
