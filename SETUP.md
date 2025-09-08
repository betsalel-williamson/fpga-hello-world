# Setup Instructions

This document outlines the necessary steps to set up your local development environment for working with this FPGA project, including tools for AWS, Git, Verilog, and GitHub Actions linting.

**Note:** While the primary focus of these instructions is on macOS, contributions for other operating systems are highly welcome!

## 1. AWS CLI

The AWS Command Line Interface (CLI) is essential for interacting with AWS services. Follow the official installation guide for your operating system.

-   **Installation Guide:** [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

-   **Verification:** After installation, verify by running:

    ```bash
    aws --version
    ```

## 2. Git

Git is a distributed version control system used for tracking changes in source code during software development. It's crucial for collaborating on this project.

-   **Installation Guide:** [https://git-scm.com/](https://git-scm.com/)

-   **Verification:** After installation, verify by running:

    ```bash
    git --version
    ```

## 3. Verilog Development Tools (Icarus Verilog & GTKWave)

Icarus Verilog is a Verilog compiler that generates an intermediate format (VVVP) which can be executed by a simulator (vvp). GTKWave is a waveform viewer used to visualize the output of Verilog simulations.

### Mac Installation

Due to compatibility issues with GTKWave on macOS 14 (Sonoma) and later, a community Homebrew tap is recommended for installation.

4.  **Install Icarus Verilog and GTKWave from a community tap**:
    ```bash
    brew install icarus-verilog
    brew tap randomplum/gtkwave
    brew install --HEAD randomplum/gtkwave/gtkwave
    ```

-   **Verification:** After installation, verify by running:

    ```bash
    iverilog -V
    gtkwave --version
    ```

### Viewing Simulation Output Online

For quick online viewing of VCD files, you can use [Fliplot](https://raczben.github.io/fliplot/). Simply drag and drop your `.vcd` file onto the website.

## 4. GitHub Actions Linting (actionlint)

`actionlint` is a linter for GitHub Actions workflow files. It helps catch common errors and ensures your workflows adhere to best practices.

### Mac Installation

Use Homebrew to install `actionlint`:

```bash
brew install actionlint
```

-   **Verification:** After installation, verify by running:

    ```bash
    actionlint -help
    ```