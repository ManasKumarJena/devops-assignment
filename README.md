DevOps Assignment – Automated Infrastructure & Deployment

Overview
This project demonstrates an end-to-end DevOps workflow where cloud infrastructure is provisioned automatically and a containerized application is deployed using CI/CD best practices.

The main goal of this assignment is to show:

Infrastructure provisioning using Terraform
Automated deployment using GitHub Actions
Secure secrets management without hardcoding
Running a Dockerized application on an EC2 instance
All steps are automated and triggered from a GitHub push.

High-level flow of the system:

GitHub Push
   ↓
GitHub Actions (CI/CD)
   ↓
Terraform provisions AWS infrastructure
   ↓
EC2 instance created with IAM Role
   ↓
AWS SSM Run Command deploys Docker app
   ↓
Docker container runs application
   ↓
Application fetches secret at runtime from SSM Parameter Store


Technologies Used

Terraform – Infrastructure as Code
GitHub Actions – CI/CD automation
AWS EC2 – Compute instance
AWS IAM – Role-based access for EC2
AWS Systems Manager (SSM) – Secure access and deployment
SSM Parameter Store – Secure secrets storage
Docker – Containerization
Python (Flask) – Sample application


Infrastructure Details

Terraform provisions the following resources:
EC2 instance
IAM role and instance profile
Security group (port 80 open)
SSM Parameter Store secret (SecureString)
IAM policies to allow EC2 to read the secret
All infrastructure is created automatically during the CI/CD pipeline run.

CI/CD Pipeline (GitHub Actions)
The pipeline is triggered on every push to the main branch.

What the pipeline does:

Checks out the repository
Authenticates to AWS using GitHub Secrets
Runs terraform init and terraform apply
Uses AWS SSM Run Command to:
Install Docker
Clone the repository on EC2
Build the Docker image
Run the container
No SSH access or PEM keys are used.


Secrets Management
Secrets are not hardcoded anywhere in the codebase.

Secrets are stored in AWS Systems Manager Parameter Store
Type: SecureString
The EC2 instance reads the secret using its IAM role
The application fetches the secret at runtime using the AWS SDK
This is verified by application logs showing:
"✅ Secret fetched successfully"


Application
The application is a simple Flask app running inside a Docker container.

Exposed via port 80
Internally runs on port 5000
Accessible using the EC2 public IP:
"http://http://13.201.100.198/"
The app confirms successful startup and secret retrieval.

Verification & Evidence
To verify the deployment:

GitHub Actions
Successful workflow run (green)

AWS EC2
Instance named devops-assignment in running state

Secrets
Parameter visible in AWS Systems Manager → Parameter Store

Application Logs
Docker logs show successful secret retrieval



Security Notes

No secrets are committed to the repository
No SSH keys or PEM files are used
IAM roles are used instead of static credentials
AWS root credentials were used only for assignment simplicity and stored securely in GitHub Secrets


Automation Clarification
The system is fully automated by design.

Infrastructure creation is automated via Terraform
Deployment is automated via GitHub Actions and AWS SSM
The application always fetches secrets automatically at runtime

During the initial setup, Docker installation was verified manually due to OS-specific behavior.
After that, all future deployments are handled automatically on each GitHub push.



How to Trigger the Pipeline
Simply push any change to the main branch:

"git push origin main"

The CI/CD pipeline will run automatically.


Conclusion
This project demonstrates a complete DevOps workflow:

Infrastructure as Code
Automated deployments
Secure secrets handling
Containerized applications
Cloud-native access without SSH

.