---
inclusion: manual
---

# User Story: FPGA Hello World on AWS

## User Persona

**Name:** Cloud FPGA Engineer
**Description:** A developer focused on deploying and managing FPGA workloads in cloud environments, specifically AWS. They are concerned with the operational aspects, cost efficiency, and reliability of cloud-based FPGA solutions.

- **As a** Cloud FPGA Engineer
- **I want to** reliably deploy a pre-built FPGA "Hello World" AFI to an AWS F1 instance via a controlled CI process
- **so that** I can validate the cloud deployment pipeline, understand the monetary costs, deployment times, execution times, and power consumption associated with AWS FPGA operations, and ensure the resilience of the cloud deployment process.

## Acceptance Criteria

- WHEN I manually trigger the deployment of the "Hello World" AFI to an AWS FPGA instance via the CI interface THEN I SHALL see a clear indication of successful deployment.
- WHEN the "Hello World" example is executed on the AWS FPGA instance THEN I SHALL observe the expected output.
- WHEN the "Hello World" example is deployed and executed on AWS THEN I SHALL be able to identify and record the monetary cost incurred for the AWS resources used.
- WHEN the "Hello World" example is deployed to AWS THEN I SHALL be able to measure and record the time taken for the deployment process.
- WHEN the "Hello World" example is executed on AWS THEN I SHALL be able to measure and record the time taken for its execution.
- WHEN the "Hello World" example is executed on AWS THEN I SHALL be able to estimate and record the power consumption of the FPGA instance during its operation.
- WHEN a deployment of the "Hello World" example to AWS fails THEN I SHALL be able to measure the mean time to restore (MTTR) the successful state.

## Success Metrics

- **Primary Metric**: Successful deployment and execution of the "Hello World" example on an AWS FPGA instance, with observable output, triggered via CI.
- **Secondary Metrics**:
    - Documented monetary cost for the AWS FPGA instance and associated services per execution/hour.
    - Documented deployment time to AWS.
    - Documented execution time on AWS.
    - Estimated power consumption of the AWS FPGA instance during execution.
    - Documented Mean Time To Restore (MTTR) for failed AWS deployments.
