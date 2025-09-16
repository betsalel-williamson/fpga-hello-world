# Design: Mise-en-place Migration

## 1. Objective

To migrate the project's task management from `Makefile`s to `mise-en-place` for unified task management and improved developer experience, extending to `src/` sub-repositories. This migration also includes integrating `hk` for managing commit hooks and linters, and establishing code formatters for HDLs.

## 2. Technical Design

The migration involves replacing `Makefile`s in `src/systemverilog/hello_world/`, `src/verilog/hello_world/`, and `src/vhdl/hello_world/` with equivalent tasks defined in new `mise.toml` files within those directories. A root `mise.toml` file will be introduced to define global tools (e.g., `python`) and orchestrate `install-all` and `clean-all` tasks for these `src/` sub-repositories, delegating sub-repository specific build and initialization tasks to their respective `mise.toml` files. Additionally, `hk` will be integrated to manage commit hooks and linters, ensuring code quality and consistency. For HDL code formatting, `Verible` will be used for SystemVerilog and Verilog, and `vhdlfmt` will be used for VHDL. **Note: HDL tools (`verilator`, `iverilog`, `ghdl`, `verible-verilog-format`, `vhdlfmt`) are assumed to be installed manually on the system and available in the PATH. Future work may involve integrating these into a tool manager like Aqua or Mise registry.** This aligns with the project's goal of consolidating tooling and simplifying the development environment setup.

## 3. Key Changes

### 3.1. API Contracts

N/A

### 3.2. Data Models

N/A

### 3.3. Component Responsibilities

- **`Makefile`s**: Will be removed from `src/systemverilog/hello_world/`, `src/verilog/hello_world/`, and `src/vhdl/hello_world/`.
- **Root `mise.toml`**: A new file introduced at the project root to define and manage project-level tools (e.g., `python`) and global orchestration tasks (e.g., `install-all`, `clean-all`). It will *not* contain sub-repository specific build or initialization tasks.
- **Sub-repository `mise.toml` files**: New files in `src/systemverilog/hello_world/`, `src/verilog/hello_world/`, and `src/vhdl/hello_world/` to define and manage tasks specific to those sub-projects, including their build and initialization processes.
- **`hk` integration**: `hk` will be used to manage commit hooks and linters, ensuring consistent code quality.
- **HDL Formatters**: `Verible` will be integrated for SystemVerilog and Verilog formatting, and `vhdlfmt` for VHDL formatting. These tools are expected to be installed manually on the system.

## 4. Alternatives Considered

- **Keeping `Makefile`s**: Rejected because it fragments task management across different tools and doesn't align with the goal of a unified development environment.
- **Only root `mise.toml`**: Rejected as it would make sub-repository specific tasks less discoverable and harder to manage independently.

## 5. Out of Scope

- Migration of `make` specific features beyond script execution.
- Direct management of HDL tools (`verilator`, `iverilog`, `ghdl`, `verible-verilog-format`, `vhdlfmt`) by `mise` or `aqua` in this phase.