### No shell commands in this lab
# Add users and groups to an AWS Directory Service Simple AD directory.
# Associate directory users with an IAM role to define AWS Management Console access.
# Sign in to the AWS Management Console as a directory user.
# Remove access for a malicious user.

### Scenario:
# As a security engineer at AnyCompany, you want to allow company employees to sign in to the AWS Management Console with their corporate credentials, rather than to have to maintain a list of IAM users.
# Only specific job roles are allowed to interact with the AWS Management Console, and their permissions must be limited to the minimum required to perform their daily tasks.
# To start, you want to create two types of roles—one that allows the infrastructure management team to view any Amazon Elastic Compute Cloud (Amazon EC2) instances, and one that allows storage administrators to manage Amazon Simple Storage Service (Amazon S3) buckets.
# If you discover that users are violating company policies, or acting in malicious ways, you want to be able to remove their access quickly.

### Lab environment:
# One VPC.
# Two public subnets, with one copy of the AWS Directory Service Simple AD directory in each subnet.
# One private subnet, with one Windows-based Amazon EC2 instance.
# End users authenticating to the AWS Management Console through the Simple AD directory.
