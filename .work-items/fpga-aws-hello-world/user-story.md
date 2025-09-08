---
inclusion: manual
---

# User Story: FPGA AWS Hello World

## User Persona

**Name:** FPGA Explorer
**Description:** A software or hardware developer who is new to FPGAs and wants to understand their practical application and development workflow, particularly within cloud environments like AWS. They are interested in the tangible aspects of FPGA development, such as performance, resource usage, and operational costs.

- **As an** FPGA Explorer
- **I want to** successfully deploy and execute a basic "Hello World" example on an AWS FPGA instance
- **so that** I can gain foundational knowledge of the AWS FPGA development and deployment process, and understand the associated costs (monetary, development time, deployment time, execution time, and power consumption) for future project planning, and assess the resilience of the development pipeline.

## Acceptance Criteria

- WHEN I deploy the "Hello World" example to an AWS FPGA instance THEN I SHALL see a clear indication of successful deployment.
- WHEN I execute the "Hello World" example on the AWS FPGA instance THEN I SHALL observe the expected output.
- WHEN the "Hello World" example is developed THEN I SHALL be able to measure and record the total time spent on its development.
- WHEN the "Hello World" example is deployed and executed THEN I SHALL be able to identify and record the monetary cost incurred for the AWS resources used.
- WHEN the "Hello World" example is deployed THEN I SHALL be able to measure and record the time taken for the deployment process.
- WHEN the "Hello World" example is executed THEN I SHALL be able to measure and record the time taken for its execution.
- WHEN the "Hello World" example is executed THEN I SHALL be able to estimate and record the power consumption of the FPGA instance during its operation.
- WHEN a build or deployment of the "Hello World" example fails THEN I SHALL be able to measure the mean time to restore (MTTR) the successful state.

## Success Metrics

- **Primary Metric**: Successful deployment and execution of the "Hello World" example on an AWS FPGA instance, with observable output.
- **Secondary Metrics**:
    - Documented total development time for the "Hello World" example.
    - Documented monetary cost for the AWS FPGA instance and associated services per execution/hour.
    - Documented deployment time.
    - Documented execution time.
    - Estimated power consumption of the FPGA instance during execution.
    - Documented Mean Time To Restore (MTTR) for failed builds and deployments.