#!/bin/bash
set -euo pipefail

# Update and install dependencies (Amazon Linux 2023)
dnf -y update
dnf -y install java-17-amazon-corretto awscli

# Create application directory
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# Download application JAR from S3 (requires IAM role on the instance)
aws s3 cp "s3://<S3-BUCKET-NAME>/couponservice-0.0.1-SNAPSHOT.jar" .

# Generate Spring Boot configuration at startup (do NOT commit real values to GitHub)
cat << 'EOF' > /home/ec2-user/app/application.yml
spring:
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect

  datasource:
    url: jdbc:mysql://<RDS-ENDPOINT>:3306/<DB-NAME>
    username: <DB-USERNAME>
    password: <DB-PASSWORD>
    driver-class-name: com.mysql.cj.jdbc.Driver

server:
  port: 9091
EOF

# Start the service (log to file)
nohup java -jar /home/ec2-user/app/couponservice-0.0.1-SNAPSHOT.jar \
  > /home/ec2-user/app/app.log 2>&1 &