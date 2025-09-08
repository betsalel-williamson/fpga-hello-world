---
inclusion: manual
---

# Task: FPGA Hello World on AWS Deployment Implementation

## Objective

Implement the AWS deployment aspects of the "FPGA Hello World" design, focusing on a manually-triggered, cost-conscious approach via the CI interface. This includes defining AWS infrastructure as code, developing a host application, integrating monitoring for cost/time/power, establishing MTTR measurement for deployment failures, and implementing **proactive budget guardrails**.

## Requirements Traceability

-   User Story: `user-story.md`
-   Design: `design.md`

## Sequential Steps (Red-Green-Refactor)

### 1. Define AWS Infrastructure as Code (IaC)

-   **Objective:** Create AWS CloudFormation or Terraform templates to provision the necessary AWS resources, including an EC2 F1 instance and an S3 bucket for AFI storage.
-   **Acceptance Criteria:**
    -   IaC templates (`cloudformation.yaml` or `main.tf`) are created for the F1 instance and S3 bucket.
    -   Templates are syntactically correct and pass validation.
-   **Test Strategy:** Use `aws cloudformation validate-template --template-body file://cloudformation.yaml` or `terraform validate` to verify template correctness.

### 2. Configure Manually Triggered AWS Deployment (CI/CD - Deploy Stage)

-   **Objective:** Extend the CI/CD pipeline to include a deployment stage that can be manually triggered to deploy the generated AFI to the provisioned EC2 F1 instance and update the AWS infrastructure as defined by the IaC.
-   **Acceptance Criteria:**
    -   The CI/CD workflow (`.github/workflows/fpga-ci.yaml` or a new deployment-specific workflow) is updated to include a deployment stage.
    -   This stage is configured to be manually triggered (e.g., using `workflow_dispatch` in GitHub Actions).
    -   The pipeline successfully deploys the AFI to an F1 instance upon manual trigger.
    -   The F1 instance is running with the custom AFI loaded.
    -   The AWS infrastructure is updated via IaC upon manual trigger when necessary.
-   **Test Strategy:** Manually trigger the deployment stage in the CI interface, then verify the F1 instance status and AFI association in the AWS console, and confirm the IaC stack update.

### 3. Develop Basic Host Application

-   **Objective:** Create a simple host application (e.g., in C/C++ or Python) that runs on the EC2 F1 instance, loads the AFI, interacts with the FPGA (e.g., writes to/reads from a register, observes a counter), and verifies the "Hello World" functionality.
-   **Acceptance Criteria:**
    -   A host application (`host_app.c` or `host_app.py`) is created.
    -   The application compiles/runs successfully on the F1 instance.
    -   The application successfully communicates with the FPGA and demonstrates the "Hello World" output.
-   **Test Strategy:** Execute the host application on the F1 instance and verify its output, confirming interaction with the FPGA.

### 4. Integrate Monitoring for Cost, Time, and Power

-   **Objective:** Implement mechanisms to capture and log monetary cost, deployment time, execution time, and estimated power consumption data for the FPGA workflow on AWS.
-   **Acceptance Criteria:**
    -   Scripts or AWS monitoring configurations are in place to collect the specified metrics.
    -   Metrics are logged (e.g., to AWS CloudWatch, S3, or a local file).
    -   The collected data is accessible and interpretable.
-   **Test Strategy:** Run a full deployment and execution cycle (including the manually triggered deployment step), then verify the presence and content of the collected metrics in the designated storage location.

### 5. Implement Budget Guardrails

-   **Objective:** Configure AWS budget alerts and other proactive mechanisms to provide early warnings and prevent cost overruns.
-   **Acceptance Criteria:**
    -   AWS budget alerts are configured for the relevant services (e.g., EC2 F1, S3) with appropriate thresholds.
    -   Notification channels (e.g., email, SNS topic) are set up for budget alerts.
    -   A test alert is triggered and verified to ensure notifications are received.
-   **Test Strategy:** Configure a low budget threshold to intentionally trigger an alert, then verify that the notification is received. Alternatively, review AWS Cost Explorer and Budget reports to confirm the budget is active and monitoring costs.

### 6. Implement Mean Time To Restore (MTTR) Measurement for AWS Deployment

-   **Objective:** Introduce a process to simulate failures in the AWS deployment pipeline and measure the time taken to identify, fix, and restore the system to a successful operational state.
-   **Acceptance Criteria:**
    -   A documented procedure for simulating AWS deployment failures (e.g., misconfiguring IaC, incorrect AFI association) is established.
    -   A method for accurately measuring and recording MTTR for AWS deployments is implemented.
    -   A simulated AWS deployment failure is introduced, fixed, and the MTTR is successfully measured and logged.
-   **Test Strategy:** Intentionally introduce a known failure into the IaC or deployment configuration, manually trigger the CI/CD deployment pipeline, resolve the issue, and verify that the MTTR is accurately calculated and recorded.

### 7. Implement Automated Teardown of AWS Resources

-   **Objective:** Create and integrate scripts or CI/CD steps to automatically or manually trigger the de-provisioning of AWS resources (EC2 F1 instance, S3 buckets) after testing to minimize costs.
-   **Acceptance Criteria:**
    -   A script (e.g., `teardown-aws-resources.sh`) or IaC command is created to destroy the AWS infrastructure.
    -   This teardown mechanism can be easily triggered (e.g., via a separate CI job or local execution).
    -   Upon execution, AWS resources are successfully de-provisioned.
-   **Test Strategy:** After a successful deployment and testing, execute the teardown mechanism and verify in the AWS console that all relevant resources have been terminated.