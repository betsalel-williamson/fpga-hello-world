---
inclusion: manual
---

# Task: FPGA AWS Hello World Implementation

## Objective

Implement the "FPGA AWS Hello World" user story and design, following a Red-Green-Refactor approach for each step to establish a baseline for FPGA development on AWS, including measurement of monetary cost, development time, deployment time, execution time, power consumption, and Mean Time To Restore (MTTR).

## Requirements Traceability

-   User Story: `user-story.md`
-   Design: `design.md`

## Sequential Steps (Red-Green-Refactor)

### 1. Setup Local Development Environment

-   **Objective:** Install and configure all necessary local development tools for FPGA design and AWS interaction.
-   **Acceptance Criteria:**
    -   AWS CLI is installed and configured. - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
    -   Git is installed.
    -   A Verilog linter/simulator (e.g., Icarus Verilog) is installed and functional.
-   **Test Strategy:** Execute `aws --version`, `git --version`, and a simple `iverilog` command to verify installations and basic functionality.

### 2. Create Minimal HDL "Hello World" Design

-   **Objective:** Develop a simple, synthesizable Verilog module that represents a basic "Hello World" equivalent (e.g., a register that can be written to and read from, or a simple counter).
-   **Acceptance Criteria:**
    -   A Verilog file (`hello_world.v`) is created with a basic, synthesizable design. [x]
    -   A `Makefile` is created to automate build, simulate, and verify. [x]
    -   A `verify_simulation.sh` script is created to verify simulation output. [x]
    -   The design passes Verilog linting/syntax checks. [x]
-   **Test Strategy:** Run `make -C src/verilog/hello_world test` to ensure no syntax errors, successful compilation, simulation, and verification of output. [x]

### 3. Define AWS Infrastructure as Code (IaC)

-   **Objective:** Create initial AWS CloudFormation or Terraform templates to provision the necessary AWS resources, including an EC2 F1 instance and an S3 bucket for AFI storage.
-   **Acceptance Criteria:**
    -   IaC templates (`cloudformation.yaml` or `main.tf`) are created for the F1 instance and S3 bucket.
    -   Templates are syntactically correct and pass validation.
-   **Test Strategy:** Use `aws cloudformation validate-template --template-body file://cloudformation.yaml` or `terraform validate` to verify template correctness.

### 4. Create and Publish FPGA Development Environment Docker Image (CI Workflow)

-   **Objective:** Create a Dockerfile to build a specialized image containing all necessary FPGA development tools and dependencies, and integrate its build and publish into a dedicated CI workflow.
-   **Acceptance Criteria:**
    -   A `Dockerfile` is created in `docker/fpga-dev-env/Dockerfile`. [x]
    -   A `.dockerignore` file is created for the Docker build context. [x]
    -   The Dockerfile successfully builds into an image locally.
    -   The image contains `iverilog` and other required tools.
    -   A dedicated CI workflow (`.github/workflows/fpga-ci.yaml`) is created to build and publish this Docker image to GHCR. [x]
-   **Test Strategy:** Run `docker build -t fpga-dev-env ./docker/fpga-dev-env` and then `docker run fpga-dev-env iverilog -V` to verify the image builds and contains the necessary tools. Observe the `fpga-ci.yaml` workflow for successful Docker image build and publish.

### 5. Automate AFI Build and Simulation Process (CI/CD - Build Stage)

-   **Objective:** Set up a CI/CD pipeline to automatically trigger the AWS FPGA Development Kit (AFDK) build and simulation process upon changes to the HDL design, utilizing the pre-built and published FPGA Development Environment Docker Image.
-   **Acceptance Criteria:**
    -   The CI workflow (`.github/workflows/fpga-ci.yaml`) is updated to depend on the Docker image build workflow and uses the published FPGA Development Environment Docker Image for the build and simulate steps. [x]
    -   The pipeline successfully triggers on code push, pulls the HDL, and initiates the AFDK build and simulation process (simulated by `iverilog` build/simulate) within the Docker container. [x]
    -   A placeholder AFI is generated (or the build process completes without errors, even if the AFI is not yet fully functional). [x]
    -   The `hello_world.vvp` and `hello_world.vcd` files are uploaded as workflow artifacts. [x]
-   **Test Strategy:** Push a minor change to `hello_world.v`, observe the `fpga-ci.yaml` workflow execution, and verify that the `make test` command completes successfully using the Docker image, and that the simulation artifacts are available for download.

### 6. Automate AWS Deployment (CI/CD - Deploy Stage)

-   **Objective:** Extend the CI/CD pipeline to deploy the generated AFI to the provisioned EC2 F1 instance and update the AWS infrastructure as defined by the IaC.
-   **Acceptance Criteria:**
    -   The CI/CD workflow is updated to include a deployment stage.
    -   The pipeline successfully deploys the AFI to an F1 instance.
    -   The F1 instance is running with the custom AFI loaded.
-   **Test Strategy:** Trigger the CI/CD pipeline, verify the F1 instance status and AFI association in the AWS console, and confirm the IaC stack update.

### 7. Develop Basic Host Application

-   **Objective:** Create a simple host application (e.g., in C/C++ or Python) that runs on the EC2 F1 instance, loads the AFI, interacts with the FPGA (e.g., writes to/reads from a register, observes a counter), and verifies the "Hello World" functionality.
-   **Acceptance Criteria:**
    -   A host application (`host_app.c` or `host_app.py`) is created.
    -   The application compiles/runs successfully on the F1 instance.
    -   The application successfully communicates with the FPGA and demonstrates the "Hello World" output.
-   **Test Strategy:** Execute the host application on the F1 instance and verify its output, confirming interaction with the FPGA.

### 8. Integrate Monitoring for Cost, Time, and Power

-   **Objective:** Implement mechanisms to capture and log monetary cost, deployment time, execution time, and estimated power consumption data for the FPGA workflow.
-   **Acceptance Criteria:**
    -   Scripts or AWS monitoring configurations are in place to collect the specified metrics.
    -   Metrics are logged (e.g., to AWS CloudWatch, S3, or a local file).
    -   The collected data is accessible and interpretable.
-   **Test Strategy:** Run a full deployment and execution cycle via the CI/CD pipeline, then verify the presence and content of the collected metrics in the designated storage location.

### 9. Implement Mean Time To Restore (MTTR) Measurement

-   **Objective:** Introduce a process to simulate failures in the build or deployment pipeline and measure the time taken to identify, fix, and restore the system to a successful operational state.
-   **Acceptance Criteria:**
    -   A documented procedure for simulating failures (e.g., introducing a syntax error in HDL, misconfiguring IaC) is established.
    -   A method for accurately measuring and recording MTTR is implemented.
    -   A simulated failure is introduced, fixed, and the MTTR is successfully measured and logged.
-   **Test Strategy:** Intentionally introduce a known failure into the HDL or IaC, trigger the CI/CD pipeline, resolve the issue, and verify that the MTTR is accurately calculated and recorded.

### 10. Create and Update Project Documentation

-   **Objective:** Create a `README.md` file and update it to reflect the project's purpose, setup instructions, and CI/CD status.
-   **Acceptance Criteria:**
    -   A `README.md` file is created at the project root.
    -   The `README.md` includes a project title, a brief description, setup instructions for local development, and a badge indicating the status of the Verilog CI workflow.
    -   A `LICENSE` file (MIT) is present at the project root. [x]
-   **Test Strategy:** Verify the presence and content of `README.md` and `LICENSE` files.