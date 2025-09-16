# Task: Mise-en-place Migration

## Clear Objective

Migrate the project's task management from `Makefile`s to `mise-en-place` by creating a root `mise.toml` file, removing `Makefile`s from `src/` subdirectories, and establishing `mise.toml` files in `src/` subdirectories for their specific tasks. The root `mise.toml` will focus on global tools (e.g., `python`) and orchestration, delegating sub-repository specific tasks. Integrate `hk` for managing commit hooks and linters, and establish code formatters for HDLs. **Note: HDL tools (`verilator`, `iverilog`, `ghdl`, `verible-verilog-format`, `vsg`) are assumed to be installed manually on the system and available in the PATH. Future work may involve integrating these into a tool manager like Aqua or Mise registry.**

## Acceptance Criteria

- A `mise.toml` file exists at the project root with global tools (e.g., `python`) and orchestration tasks.
- `mise.toml` files exist in `src/systemverilog/hello_world/`, `src/verilog/hello_world/`, and `src/vhdl/hello_world/` with their respective tasks.
- `Makefile`s are removed from `src/systemverilog/hello_world/`, `src/verilog/hello_world/`, and `src/vhdl/hello_world/`.
- All original `Makefile` tasks can be executed successfully via `mise run <task-name>` or `mise run <task-name> -C <path>`.
- Global tasks like `install-all`, `clean-all` function correctly.
- `hk` is integrated to manage commit hooks and linters.
- `Verible` is configured for SystemVerilog and Verilog formatting, and `vsg` for VHDL formatting. These tools are expected to be installed manually on the system.

## Requirements Traceability

This task supports the overall goal of unifying task management and improving developer experience across the entire project.

## Test Strategy

1. Verify the existence and content of all `mise.toml` files.
2. Verify the removal of `Makefile`s from `src/systemverilog/hello_world/`, `src/verilog/hello_world/`, and `src/vhdl/hello_world/`.
3. Run each migrated root task using `mise run <task-name>` and ensure they execute correctly.
4. Run global orchestration tasks:
    - `mise install`
    - `mise run install-all`
    - `mise run clean-all`
5. Run sub-repository specific tasks (e.g., `mise run build -C src/systemverilog/hello_world/`, `mise run test -C src/verilog/hello_world/`).
6. Verify `hk` is correctly configured and commit hooks/linters are working as expected.
7. Verify that `Verible` formats SystemVerilog and Verilog files correctly, and `vsg` formats VHDL files correctly.

# Task Step: Update Root mise.toml for Sub-repository Management and Global Tasks

## Clear Objective

Update the root `mise.toml` file to include a `[tools]` section for managing language versions, global tasks for installing and cleaning sub-repositories. Ensure that sub-repository specific tasks are handled by their respective sub-repository `mise.toml` files. Integrate `hk` for commit hooks and linters, and configure HDL formatters. **Note: HDL tools (`verilator`, `iverilog`, `ghdl`, `verible-verilog-format`, `vsg`) are assumed to be installed manually on the system and available in the PATH. Future work may involve integrating these into a tool manager like Aqua or Mise registry.**

## Acceptance Criteria

- The `mise.toml` file at the project root contains a `[tools]` section specifying `python` version.
- The `mise.toml` file contains `install`, `install-all`, `clean`, `clean-all` tasks.
- The `install-all` task correctly uses `mise run install -C <path>` for `src/systemverilog/hello_world/`, `src/verilog/hello_world/`, and `src/vhdl/hello_world/`.
- The `clean-all` task correctly uses `mise run clean -C <path>` for `src/systemverilog/hello_world/`, `src/verilog/hello_world/`, and `src/vhdl/hello_world/`.
- `hk` is configured in the root `mise.toml` to run commit hooks and linters.
- `Verible` and `vsg` are configured in the root `mise.toml` or relevant sub-repository `mise.toml` files for formatting HDL code. These tools are expected to be installed manually on the system.

## Requirements Traceability

This task further enhances the unified task management and developer experience by centralizing tool version management and providing convenient commands for sub-repository setup, aligning with the overall `mise-en-place` migration design.

## Test Strategy

1. Verify the content of the updated `mise.toml` file at the root.
2. Run `mise install` to ensure specified tools are installed.
3. Run `mise run install-all` and observe output to confirm it attempts to install dependencies in `src/systemverilog/hello_world/`, `src/verilog/hello_world/`, and `src/vhdl/hello_world/`.
4. Run `mise run clean-all` and observe output to confirm it attempts to clean sub-repositories.
5. Trigger a commit to verify `hk` runs commit hooks and linters as expected.
6. Run formatting commands (e.g., `mise run format -C src/systemverilog/hello_world/`) and verify that HDL files are formatted correctly.