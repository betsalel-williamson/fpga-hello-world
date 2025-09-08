---
inclusion: manual
---

# Design: FPGA AWS Hello World

## 1. Objective

To define the technical approach for deploying and executing a basic "Hello World" example on an AWS FPGA instance, establishing a baseline for understanding the development workflow, resource utilization, and performance characteristics, with a focus on measuring monetary cost, deployment/execution time, and power consumption, all managed through GitOps principles.

## 2. Technical Design

The "Hello World" example will involve a simple FPGA design (e.g., blinking an LED or a basic counter) implemented using a hardware description language (HDL) like Verilog or VHDL. This design will be synthesized, placed, and routed to generate a custom Amazon FPGA Image (AFI). The AFI and the necessary AWS infrastructure will be defined as code and managed through a GitOps workflow. This will ensure that all deployments to an AWS EC2 F1 instance are automated and version-controlled. A host application (e.g., C/C++ or Python) running on the EC2 instance will interact with the FPGA to demonstrate the "Hello World" functionality.

The process will involve:
-   **HDL Design:** A minimal "Hello World" equivalent (e.g., a simple register that can be written to and read from, or a counter).
-   **AWS FPGA Development Kit (AFDK):** Utilizing the AFDK for synthesis, place, and route to generate the AFI.
-   **Infrastructure as Code (IaC):** Defining AWS resources (e.g., EC2 F1 instance, S3 buckets for AFI storage) using tools like AWS CloudFormation or Terraform, managed in a Git repository.
-   **CI/CD Pipeline:** An automated pipeline (e.g., AWS CodePipeline, GitHub Actions) triggered by Git commits to build the AFI, provision/update the AWS infrastructure, and deploy the host application.
-   **AWS EC2 F1 Instance:** The target platform for deploying the AFI and running the host application, provisioned and managed via IaC.
-   **Host Application:** A simple program to load the AFI, interact with the FPGA, and verify functionality, deployed via the CI/CD pipeline.
-   **Monitoring:** Implementing mechanisms to capture cost, time, and power consumption data, integrated into the automated workflow.

## 3. Key Changes

### 3.1. API Contracts

N/A for this initial "Hello World" example, as the interaction will be primarily through low-level FPGA interfaces (e.g., AXI-Lite) exposed by the AFDK, rather than high-level APIs.

### 3.2. Data Models

N/A for this initial "Hello World" example.

### 3.3. Component Responsibilities

-   **FPGA Design (HDL):** Implements the core "Hello World" logic.
-   **AFDK Toolchain:** Compiles the HDL into an AFI.
-   **IaC Definitions:** Defines and manages the AWS infrastructure required for deployment.
-   **CI/CD Pipeline:** Automates the build, deployment, and update processes based on Git commits.
-   **AWS EC2 F1 Instance:** Provides the hardware platform for the FPGA and runs the host application, managed by IaC.
-   **Host Application:** Manages AFI loading, communicates with the FPGA, and reports results, deployed via CI/CD.
-   **Monitoring Scripts/Tools:** Collects and logs metrics related to cost, time, and power, integrated into the automated workflow.

## 4. Alternatives Considered

-   **Manual AWS Resource Provisioning:** Rejected in favor of GitOps to ensure repeatability, version control, and to avoid manual errors in deployment and configuration.
-   **Local FPGA Development Board:** Considered for initial learning, but AWS F1 instances were chosen to specifically address the cloud deployment aspect and cost/time/power considerations in a cloud environment.
-   **Different HDLs/Frameworks:** While other HDLs (VHDL) or high-level synthesis (HLS) frameworks exist, Verilog will be used for simplicity and broad compatibility for the initial "Hello World".

## 5. Out of Scope

-   Complex FPGA designs beyond "Hello World" functionality.
-   Optimization for performance or resource utilization beyond basic functionality.
-   Detailed power analysis requiring specialized hardware tools (estimation will be based on AWS metrics where available).
-   Integration with other AWS services beyond EC2 F1.
-   Yolo 4 Tiny or Mojo projects (these are future phases).
-   Additional examples using other HDLs or high-level synthesis (HLS) frameworks, or targeting different FPGA platforms (cloud or local development environments) are considered future work.