# Setup Instructions

This document outlines the necessary steps to set up your local development environment for working with this FPGA project, including tools for Docker, Verilog, SystemVerilog, VHDL, GitHub Actions linting, and AWS.

**Note:** While the primary focus of these instructions is on macOS, contributions for other operating systems are highly welcome!

## GeminiCLI

Add a `.env` with necessary credentials to use GeminiCLI. The git submodule `genai-specs` contains all of the necessary system prompts for working with projects.

## 1. Docker

Docker is used to build and run the specialized FPGA development environment image, ensuring a consistent and reproducible build process. For macOS users, especially those with Apple Silicon, [Colima](https://github.com/abiosoft/colima) is a recommended lightweight alternative to Docker Desktop.

- **Installation Guide (Docker Desktop):** [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

- **Verification:** After installation, verify by running:

    ```bash
    docker --version
    ```

### 1.1. Colima (macOS with Apple Silicon)

Colima provides a container runtime for macOS (and Linux) with minimal overhead, making it a good choice for Docker on Apple Silicon.

- **Installation:**

    ```bash
    brew install colima
    colima start
    ```

- **Verification:** After starting Colima, verify Docker is running through it:

    ```bash
    docker --version
    ```

- **Troubleshooting Volume Permissions:** If you encounter issues with Docker volumes (e.g., permissions errors when mounting local directories), you may need to update Colima's volume mounts. This can often be done by editing the Colima configuration. For example, to add a mount for your home directory, stop Colima and then start it with the `--edit` flag:

    ```bash
    colima stop
    colima start --edit
    ```

    This will open a text editor (usually `vi` or `nano`) with the Colima configuration. Locate the `mounts:` section and add your desired mount path, for example:

    ```yaml
    mounts:
      - ~/Developer:~/Developer
      - /Users/yourusername:/Users/yourusername # Example for home directory
    ```

    Save and exit the editor. Colima will then restart with the updated configuration. Refer to the [Colima documentation](https://github.com/abiosoft/colima#mounts) for more advanced mounting configurations.

## 2. HDL Development Tools (Icarus Verilog, Verilator, GHDL & GTKWave)

Icarus Verilog is a Verilog compiler that generates an intermediate format (VVVP) which can be executed by a simulator (vvp). Verilator is a fast, open-source Verilog and SystemVerilog simulator. GHDL is an open-source VHDL compiler and simulator. GTKWave is a waveform viewer used to visualize the output of Verilog/SystemVerilog/VHDL simulations.

### Mac Installation

Due to compatibility issues with GTKWave on macOS 14 (Sonoma) and later, a community Homebrew tap is recommended for installation.

- **Install Icarus Verilog and GTKWave from a community tap**:

    ```bash
    brew install icarus-verilog
    brew tap randomplum/gtkwave
    brew install --HEAD randomplum/gtkwave/gtkwave
    ```

- **Install Verilator:**

    ```bash
    brew install verilator
    ```

- **Install GHDL:**

    ```bash
    brew install ghdl
    ```

- **Verification:** After installation, verify by running:

    ```bash
    iverilog -V
    verilator --version
    ghdl --version
    gtkwave --version
    ```

### Viewing Simulation Output Online

For quick online viewing of VCD files, you can use [Fliplot](https://raczben.github.io/fliplot/). Simply drag and drop your `.vcd` file onto the website.

## 3. GitHub Actions Linting (actionlint)

`actionlint` is a linter for GitHub Actions workflow files. It helps catch common errors and ensures your workflows adhere to best practices.

### Mac Installation

Use Homebrew to install `actionlint`:

```bash
brew install actionlint
```

- **Verification:** After installation, verify by running:

    ```bash
    actionlint -help
    ```

## 4. AWS CLI

The AWS Command Line Interface (CLI) is essential for interacting with AWS services. Follow the official installation guide for your operating system.

- **Installation Guide:** [https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- **Verification:** After installation, verify by running:

    ```bash
    aws --version
    ```
