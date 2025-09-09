---
inclusion: manual
---

# Design: SystemVerilog Hello World Example

## 1. Objective

To create a minimal "Hello World" example using SystemVerilog, demonstrating basic syntax, compilation, simulation, and output verification, consistent with existing Verilog examples, utilizing Verilator for simulation.

## 2. Technical Design

The solution will involve a simple SystemVerilog module that prints a message to the console during simulation. This will be placed in the directory `src/systemverilog/hello_world/`. The compilation and simulation will be managed by a `Makefile` using **Verilator**, and a `verify_simulation.sh` script will check the output. This design aligns with the project's general approach to hardware description language examples.

## 3. Key Changes

### 3.1. API Contracts

N/A (No API contracts involved for this example).

### 3.2. Data Models

N/A (No data models involved for this example).

### 3.3. Component Responsibilities

- `src/systemverilog/hello_world/hello_world.sv`: Contains the SystemVerilog module with a simple initial block to print "Hello, SystemVerilog!".
- `src/systemverilog/hello_world/Makefile`: Manages the compilation of `hello_world.sv` using **Verilator** (specifically `verilator --timing --main --build`) and simulation.
- `src/systemverilog/hello_world/verify_simulation.sh`: Executes the simulation and checks the console output for the expected "Hello, SystemVerilog!" message.

## 4. Alternatives Considered

- **Using Icarus Verilog (iverilog):** Initially considered, but Verilator offers more robust SystemVerilog support and is a widely adopted open-source tool for high-performance simulation.
- **Using a more complex SystemVerilog feature:** Rejected to keep the example as simple as possible for a "Hello World" introduction.

## 5. Out of Scope

- Synthesis of the SystemVerilog code for an actual FPGA.
- Advanced SystemVerilog features (e.g., interfaces, classes, assertions).
- Integration with a full-fledged UVM testbench.
