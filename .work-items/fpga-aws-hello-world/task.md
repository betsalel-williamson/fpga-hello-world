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
    -   AWS CLI is installed and configured.
    -   Git is installed.
    -   A Verilog linter/simulator (e.g., Icarus Verilog) is installed and functional.
-   **Test Strategy:** Execute `aws --version`, `git --version`, and a simple `iverilog` command to verify installations and basic functionality.

### 2. Create Minimal HDL "Hello World" Design

-   **Objective:** Develop a simple, synthesizable Verilog module that represents a basic "Hello World" equivalent (e.g., a register that can be written to and read from, or a simple counter).
-   **Acceptance Criteria:**
    -   A Verilog file (`hello_world.v`) is created with a basic, synthesizable design.
    -   The design passes Verilog linting/syntax checks.
-   **Test Strategy:** Run `iverilog -tvvp hello_world.v` (or equivalent linter) to ensure no syntax errors and basic compilability.

### 3. Define AWS Infrastructure as Code (IaC)

-   **Objective:** Create initial AWS CloudFormation or Terraform templates to provision the necessary AWS resources, including an EC2 F1 instance and an S3 bucket for AFI storage.
-   **Acceptance Criteria:**
    -   IaC templates (`cloudformation.yaml` or `main.tf`) are created for the F1 instance and S3 bucket.
    -   Templates are syntactically correct and pass validation.
-   **Test Strategy:** Use `aws cloudformation validate-template --template-body file://cloudformation.yaml` or `terraform validate` to verify template correctness.

### 4. Automate AFI Build Process (CI/CD - Build Stage)

-   **Objective:** Set up a CI/CD pipeline (e.g., GitHub Actions, AWS CodePipeline) to automatically trigger the AWS FPGA Development Kit (AFDK) build process upon changes to the HDL design, generating an AFI.
-   **Acceptance Criteria:**
    -   A CI/CD workflow file (`.github/workflows/build-afi.yaml` or equivalent) is created.
    -   The pipeline successfully triggers on code push, pulls the HDL, and initiates the AFDK build process.
    -   A placeholder AFI is generated (or the build process completes without errors, even if the AFI is not yet fully functional).
-   **Test Strategy:** Push a minor change to `hello_world.v`, observe the CI/CD pipeline execution, and verify that the build stage completes successfully.

### 5. Automate AWS Deployment (CI/CD - Deploy Stage)

-   **Objective:** Extend the CI/CD pipeline to deploy the generated AFI to the provisioned EC2 F1 instance and update the AWS infrastructure as defined by the IaC.
-   **Acceptance Criteria:**
    -   The CI/CD workflow is updated to include a deployment stage.
    -   The pipeline successfully deploys the AFI to an F1 instance.
    -   The F1 instance is running with the custom AFI loaded.
-   **Test Strategy:** Trigger the CI/CD pipeline, verify the F1 instance status and AFI association in the AWS console, and confirm the IaC stack update.

### 6. Develop Basic Host Application

-   **Objective:** Create a simple host application (e.g., in C/C++ or Python) that runs on the EC2 F1 instance, loads the AFI, interacts with the FPGA (e.g., writes to/reads from a register, observes a counter), and verifies the "Hello World" functionality.
-   **Acceptance Criteria:**
    -   A host application (`host_app.c` or `host_app.py`) is created.
    -   The application compiles/runs successfully on the F1 instance.
    -   The application successfully communicates with the FPGA and demonstrates the "Hello World" output.
-   **Test Strategy:** Execute the host application on the F1 instance and verify its output, confirming interaction with the FPGA.

### 7. Integrate Monitoring for Cost, Time, and Power

-   **Objective:** Implement mechanisms to capture and log monetary cost, deployment time, execution time, and estimated power consumption data for the FPGA workflow.
-   **Acceptance Criteria:**
    -   Scripts or AWS monitoring configurations are in place to collect the specified metrics.
    -   Metrics are logged (e.g., to AWS CloudWatch, S3, or a local file).
    -   The collected data is accessible and interpretable.
-   **Test Strategy:** Run a full deployment and execution cycle via the CI/CD pipeline, then verify the presence and content of the collected metrics in the designated storage location.

### 8. Implement Mean Time To Restore (MTTR) Measurement

-   **Objective:** Introduce a process to simulate failures in the build or deployment pipeline and measure the time taken to identify, fix, and restore the system to a successful operational state.
-   **Acceptance Criteria:**
    -   A documented procedure for simulating failures (e.g., introducing a syntax error in HDL, misconfiguring IaC) is established.
    -   A method for accurately measuring and recording MTTR is implemented.
    -   A simulated failure is introduced, fixed, and the MTTR is successfully measured and logged.
-   **Test Strategy:** Intentionally introduce a known failure into the HDL or IaC, trigger the CI/CD pipeline, resolve the issue, and verify that the MTTR is accurately calculated and recorded.