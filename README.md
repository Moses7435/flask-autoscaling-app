```markdown
# 🚀 Flask Auto Scaling Deployment on AWS using Terraform & Docker

This project demonstrates how to deploy a containerized Flask application on AWS using:

- 🐳 Docker
- ⚙️ GitHub Actions (CI/CD)
- ☁️ AWS EC2
- 📈 Auto Scaling Group
- 🌐 Application Load Balancer (ALB)
- 🏗️ Terraform (Infrastructure as Code)

The system automatically scales and load-balances traffic across EC2 instances running a Dockerized Flask app.

## 🏗️ Architecture Overview

GitHub → GitHub Actions → DockerHub → AWS Auto Scaling Group → EC2 Instances → ALB → Users

### Flow:

1. Code pushed to GitHub
2. GitHub Actions builds Docker image
3. Image pushed to DockerHub
4. EC2 instances pull latest image on launch
5. ALB distributes traffic
6. Auto Scaling handles instance scaling

## 📁 Project Structure

flask-autoscaling-app/
│
├── app/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
│
├── terraform/
│   ├── main.tf
│   ├── versions.tf
│   ├── outputs.tf
│
├── .github/
│   └── workflows/
│       └── docker-build.yml
│
└── README.md

## 🐳 Flask Application

### Endpoints

- `/` → Returns JSON response with hostname (proves load balancing)
- `/health` → Used by ALB health checks

Example response:

```json
{
  "message": "Flask App Running Successfully!",
  "hostname": "ip-172-31-xx-xx"
}

## ⚙️ CI/CD Pipeline (GitHub Actions)

On every push to `main` branch:

1. Builds Docker image
2. Pushes image to DockerHub
3. Uses `latest` tag

Workflow file:

.github/workflows/docker-build.yml

## ☁️ Infrastructure (Terraform)

Terraform provisions:

* Default VPC & Subnets
* Security Groups
* Launch Template
* Application Load Balancer
* Target Group
* Auto Scaling Group
* Health Checks

### Key Features

* Dynamic SSH access restricted to your IP
* ALB health check on `/health`
* Grace period for instance boot
* Docker container auto-restart
* Rolling instance refresh supported
```
## 🚀 Deployment Instructions

### 1️⃣ Clone the repository

```bash
git clone https://github.com/your-username/flask-autoscaling-app.git
cd flask-autoscaling-app/terraform
```

### 2️⃣ Initialize Terraform

```bash
terraform init
```

### 3️⃣ Apply Infrastructure

```bash
terraform apply
```

After completion, Terraform outputs:

```
load_balancer_url = web-alb-xxxx.elb.amazonaws.com
```

Open it in browser:

```
http://<load_balancer_url>
```

## 🔄 Updating the Application

1. Modify Flask app inside `app/`
2. Push to GitHub:

```bash
git add .
git commit -m "Update app"
git push origin main
```

3. GitHub Actions builds & pushes new Docker image
4. Trigger instance refresh:

```bash
terraform apply
```

Or terminate ASG instances to pull new image.


## 📈 Auto Scaling

* Minimum instances: 1
* Maximum instances: 2 (configurable)
* Health check type: ELB
* Grace period: 180 seconds

Instances automatically register/deregister from Target Group.


## 🔐 Security

* SSH restricted to dynamic public IP
* EC2 only accepts HTTP from ALB
* ALB exposed to internet on port 80


## 🧠 Key DevOps Concepts Demonstrated

* Infrastructure as Code (Terraform)
* Immutable Infrastructure
* CI/CD with GitHub Actions
* Docker containerization
* Application Load Balancing
* Health checks & rolling updates
* Auto Scaling architecture


## 🛠️ Technologies Used

* Python 3.10
* Flask
* Gunicorn
* Docker
* GitHub Actions
* Terraform
* AWS EC2
* AWS ALB
* AWS Auto Scaling

---

## 📌 Future Improvements

* Add HTTPS using AWS ACM
* Implement CPU-based scaling policy
* Use AWS ECR instead of DockerHub
* Add CloudWatch monitoring
* Remove SSH access and use SSM only

---

## 👨‍💻 Author

Moses
Entry-Level IT & Cloud Engineer

```
