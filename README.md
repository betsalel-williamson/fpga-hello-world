# FPGA Hello World Project

<p align="center">
This project provides foundational "Hello World" examples for FPGA development, covering local setup, automated CI, and cost-conscious cloud deployment strategies.
</p>

<p align="center">
    <a href="https://github.com/betsalel-williamson/fpga-hello-world/blob/main/LICENSE">
        <img alt="License" src="https://img.shields.io/github/license/betsalel-williamson/fpga-hello-world?style=flat-square&color=blue">
    </a>
    <a href="https://github.com/betsalel-williamson/fpga-hello-world/actions/workflows/ci.yml">
        <img alt="CI Status" src="https://github.com/betsalel-williamson/fpga-hello-world/actions/workflows/fpga-ci.yaml/badge.svg">
    </a>
    <img alt="Language" src="https://img.shields.io/github/languages/count/betsalel-williamson/fpga-hello-world?style=flat-square">
    <img alt="Language" src="https://img.shields.io/github/languages/top/betsalel-williamson/fpga-hello-world?style=flat-square">
</p>

## Getting Started

Refer to [SETUP.md](SETUP.md) for detailed instructions on setting up your development environment and running the examples.

## Project Overview

This repository is structured into distinct feature areas, each with its own set of design documents, user stories, and tasks:

*   [**`fpga-hello-world-github`**](.work-items/fpga-hello-world-github/): Focuses on the core FPGA design, local simulation, and an automated GitHub Actions CI pipeline for building and simulating the FPGA design. This ensures design correctness and reproducibility.
*   [**`fpga-hello-world-aws`**](.work-items/fpga-hello-world-aws/): Extends the `github` feature by defining AWS infrastructure as code, developing a host application for the F1 instance, and establishing a *manually triggered* CI/CD deployment process to AWS. This phase emphasizes cost control and monitoring for cloud resources.
*   [**`fpga-visual-workflow-output`**](.work-items/fpga-visaul-workflow-output/): Addresses the automated generation and examination of visual outputs (primarily waveform diagrams) from the FPGA development workflow, ensuring headless operation within Docker.

## Documentation

Comprehensive design documents, user stories, and tasks for each feature are available in their respective directories under `.work-items/`. These documents provide in-depth information on objectives, technical designs, implementation steps, and cost considerations.