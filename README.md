
# AWS EC2 Auto Scaling Microservice

This project demonstrates how to deploy a stateless Spring Boot microservice on AWS EC2 using an Auto Scaling Group (ASG) and an Application Load Balancer (ALB).

The focus of the project is cloud infrastructure, automation, scalability, and reliability. It shows how AWS automatically adds or removes EC2 instances based on CPU utilization while keeping the application available and cost-efficient.

---

## Project Overview

- A Java Spring Boot REST API runs on EC2 instances
- Instances are created from a Launch Template
- An Auto Scaling Group adjusts capacity based on CPU load
- An Application Load Balancer distributes traffic and performs health checks
- Amazon RDS (MySQL) is used as a central database
- Amazon CloudWatch monitors metrics and triggers scaling actions
- A Python script is used to generate CPU load and test scaling behaviour

---

## Architecture Summary

The system is built using standard AWS components:

- Amazon EC2 – runs the Spring Boot application
- Launch Template – defines AMI, instance type, IAM role, security groups, and User Data
- Auto Scaling Group (ASG) – scales instances between 1 and 3
- Application Load Balancer (ALB) – routes traffic and checks instance health
- Amazon RDS (MySQL) – central database to keep instances stateless
- Amazon S3 – stores the application JAR for automated startup
- Amazon CloudWatch – monitors CPU utilization and scaling events

---

## Microservice Description

The application is a Spring Boot microservice called CouponService.

- Exposes REST endpoints to create and retrieve discount coupons
- Uses Spring Data JPA for database interaction
- Runs on port 9091
- Uses `/actuator/health` for load balancer health checks
- Packaged as an executable JAR using Maven

Sensitive configuration such as database credentials is not committed to the repository.

---

## EC2 Bootstrapping with User Data

Each EC2 instance configures itself automatically at launch using a User Data script:

- Installs Java 17 and AWS CLI
- Downloads the application JAR from Amazon S3
- Generates `application.yml` at runtime with database configuration
- Starts the Spring Boot service in the background and writes logs to a file

This ensures all instances are identical, stateless, and fully automated.

---

## Auto Scaling Configuration

- Minimum capacity: 1 instance
- Desired capacity: 1 instance
- Maximum capacity: 3 instances
- Scaling policy: target tracking based on average CPU utilization (70%)

When CPU usage increases beyond the threshold, new EC2 instances are launched automatically.  
When CPU usage drops, excess instances are terminated to reduce cost.

---

## Testing and Validation

Auto Scaling behaviour was validated using a controlled stress test:

- A Python script (`burn_cpu.py`) was executed via SSH to generate CPU load
- CloudWatch showed CPU utilization exceeding the scaling threshold
- The Auto Scaling Group launched additional EC2 instances automatically
- After stopping the stress test, CPU usage dropped and instances were terminated

Both scale-out and scale-in behaviour were confirmed using CloudWatch graphs and Auto Scaling activity logs.

---

## Prerequisites (If Reproducing the Setup)

- AWS account with access to EC2, ASG, ALB, RDS, S3, IAM, and CloudWatch
- Java 17 (as defined in `pom.xml`)
- Apache Maven
- IDE such as Eclipse, IntelliJ, or VS Code

To run locally:
1. Create an Amazon RDS MySQL database
2. Update the database endpoint, username, and password in `application.yml`
3. Build the project using `mvn clean package`
4. Run the generated JAR

---

## Repository Structure

couponservice/     Spring Boot application source code
scripts/           EC2 User Data script and CPU stress test
docs/              Project documentation (PDF)
.gitignore
README.md


## Documentation

A detailed project report with architecture diagrams, AWS configuration steps, screenshots, test results, and evaluation is available in the docs folder:

**[`docs/AWS Auto Scaling Project Report.pdf`](docs/AWS%20Auto%20Scaling%20Project%20Report.pdf)**



## Notes

- Build artifacts such as target/ and JAR files are intentionally excluded

- Secrets and credentials (database details, SSH keys) are not committed

- Configuration is injected at runtime using EC2 User Data

- The project focuses on AWS infrastructure, automation, and horizontal scalability

 ### AWS Cost Awareness

When creating AWS resources such as EC2 instances, Auto Scaling Groups, RDS databases, and load balancers, it is important to clean up resources after testing:

- Terminate EC2 instances and delete Auto Scaling Groups when no longer needed  
- Delete unused RDS databases and snapshots  
- Release unused Elastic IP addresses  
- Remove Application Load Balancers and associated target groups  
- Delete unused EBS volumes and S3 objects  

AWS continues to charge for certain resources even when instances are stopped, including:
- EBS storage volumes  
- Load balancers  
- Elastic IPs that are not attached to a running instance  

Failing to remove unused resources can result in unexpected charges.


## Summary

This project demonstrates a practical implementation of an auto-scaling backend service on AWS using EC2, Auto Scaling Groups, and an Application Load Balancer. It shows how cloud infrastructure can automatically respond to changing load, maintain availability, and reduce cost by scaling resources only when needed.

