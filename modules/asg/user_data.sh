#!/usr/bin/env bash

# Update system packages
yum update -y

# Install Apache web server
yum install -y httpd

# Start Apache service
systemctl start httpd

# Enable Apache service on boot
systemctl enable httpd

# Create sample web page
echo "Hello from Auto Scaling Group instance" > /var/www/html/index.html