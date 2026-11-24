# Project 15: Automate Server Configuration with Ansible

## Overview

This project demonstrates automated server configuration using **Ansible and AWS Systems Manager (SSM)**.

An Ubuntu EC2 instance is configured as a managed node, while an Ubuntu machine acts as the Ansible controller. Ansible connects to the EC2 instance through AWS Systems Manager without requiring SSH connectivity.

The Ansible playbook automates the installation and configuration of Nginx and deploys a custom HTML homepage.

## Architecture

- **Ansible Controller:** Ubuntu Linux machine
- **Managed Node:** AWS EC2 Ubuntu 24.04 instance
- **Connection Method:** AWS Systems Manager (SSM)
- **Configuration Management:** Ansible
- **Web Server:** Nginx
- **File Transfer:** Amazon S3
- **Cloud Platform:** AWS

## Technologies Used

- AWS EC2
- AWS Systems Manager (SSM)
- AWS IAM
- Amazon S3
- Ansible
- Ubuntu Linux
- Nginx
- YAML
- AWS CLI
- Python

## Project Structure

```text
project-15-ansible-automation/
│
├── ansible.cfg
├── inventory.ini
├── README.md
│
├── playbooks/
│   └── install-nginx.yml
│
├── configure-managed-node.sh
├── configure-ssh.sh
└── configure-ssh-v2.txt
```

## AWS Resources Created

| Resource | Configuration |
|---|---|
| EC2 Instance | Ubuntu 24.04, t3.micro |
| IAM Role | Project15AnsibleSSMRole |
| Instance Profile | Project15AnsibleSSMProfile |
| S3 Bucket | project-15-ansible-ssm-590507089733 |
| Security Group | project-15-ansible-sg |
| AWS Region | ap-south-1 |

The EC2 instance was associated with an IAM role containing the `AmazonSSMManagedInstanceCore` policy, allowing Systems Manager to manage the instance.

The S3 bucket is used by the Ansible SSM connection plugin for transferring files.

## Implementation Steps

### 1. Configure AWS EC2 Managed Node

- Created an Ubuntu EC2 instance.
- Configured the required security group.
- Created an IAM role with the `AmazonSSMManagedInstanceCore` policy.
- Attached the IAM instance profile to the EC2 instance.
- Verified that the SSM Agent was running.

### 2. Configure Ansible Controller

Installed Ansible and the required AWS collection.

```bash
sudo apt update
sudo apt install ansible -y
```

Installed the AWS SSM connection plugin:

```bash
ansible-galaxy collection install community.aws:==9.3.0
```

Installed the Session Manager Plugin and required Python dependencies.

### 3. Configure Ansible

Configured `ansible.cfg`:

```ini
[defaults]
inventory = ./inventory.ini
host_key_checking = False
retry_files_enabled = False
interpreter_python = auto_silent
```

Configured `inventory.ini`:

```ini
[webservers]
managed-node ansible_connection=community.aws.aws_ssm ansible_aws_ssm_instance_id=i-0714f431c4e259bff ansible_aws_ssm_region=ap-south-1 ansible_aws_ssm_bucket_name=project-15-ansible-ssm-590507089733 ansible_user=ssm-user ansible_become=true
```

### 4. Verify Ansible Connectivity

```bash
ansible webservers -m ping
```

The managed node successfully responded with:

```text
managed-node | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### 5. Create the Ansible Playbook

Created `playbooks/install-nginx.yml`.

The playbook performs the following tasks:

1. Gathers system facts.
2. Updates the Ubuntu package cache.
3. Installs Nginx.
4. Starts and enables the Nginx service.
5. Deploys a custom HTML homepage.

### 6. Validate and Execute the Playbook

Check the playbook syntax:

```bash
ansible-playbook playbooks/install-nginx.yml --syntax-check
```

Execute the playbook:

```bash
ansible-playbook playbooks/install-nginx.yml
```

### 7. Verify Nginx

Check whether Nginx is running:

```bash
ansible webservers -m command -a "systemctl is-active nginx"
```

Check whether Nginx is enabled:

```bash
ansible webservers -m command -a "systemctl is-enabled nginx"
```

### 8. Access the Website

Open the EC2 public IP in a browser:

```text
http://<EC2-PUBLIC-IP>
```

The deployed homepage displays:

**Welcome to Project 15!**

Server Configuration Automated with Ansible.

## Verification Results

The Ansible playbook completed successfully.

```text
PLAY RECAP
managed-node : ok=5 changed=3 unreachable=0 failed=0
```

The website was successfully accessed through the EC2 public IP.

HTTP response:

```text
HTTP/1.1 200 OK
Server: nginx/1.24.0 (Ubuntu)
Content-Type: text/html
```

The custom HTML homepage was returned successfully.

## Key Learnings

- Automating server configuration with Ansible.
- Connecting EC2 instances through AWS Systems Manager.
- Configuring IAM roles and instance profiles.
- Using the Ansible SSM connection plugin.
- Installing and managing Nginx through Ansible playbooks.
- Deploying website content automatically.
- Verifying cloud infrastructure and application availability.

## Author

**Project:** Project 15 - Ansible Automation  
**GitHub Repository:** Add your repository URL here.

