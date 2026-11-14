# DevOps Task — Containerized Static Website

This repository contains the implementation of the technical assessment task covering **Containerization, Docker Compose, Reverse Proxy, Automation, and CI Pipeline**.

The goal of the project is to launch a simple static website (`index.html`) in a fully containerized and automated manner, without requiring any manual steps from the user.

---

# Architecture

The project architecture has been implemented as follows:

```
                 Client
                   |
                   |
              Host Port 80
                   |
                   |
              +---------+
              |  Nginx  |
              | Reverse |
              | Proxy   |
              +---------+
                   |
                   |
              Docker Network
                   |
                   |
              +---------+
              |   tsk   |
              |  Web    |
              | Server  |
              +---------+
```

In this architecture:

- The **Nginx** container is the sole entry point from the outside.
- The web server container (`tsk`) is not directly accessible from the outside.
- Requests are received by Nginx and forwarded to the web service.

---

# Project Structure

```
.
├── README.md
└── task/
    ├── Dockerfile
    ├── docker-compose.yml
    ├── nginx.conf
    ├── index.html
    ├── setup.sh
    └── core/
        ├── tskmadules.py
        ├── createDockerfile.py
        └── dchange.py
```

---

# Docker Implementation

## Dockerfile

The Dockerfile uses the official Python image:

```
python:3.11-slim
```

Dockerfile tasks:

- Setting up the Python runtime environment
- Defining the working directory using `WORKDIR`
- Copying project files into the container
- Preparing the web server's internal port
- Running the static web server

Example:

```dockerfile
FROM python:3.11-slim

WORKDIR /runtsk

COPY . .

EXPOSE 80

CMD ["python", "-m", "http.server", "80"]
```

---

# Docker Compose

Docker Compose consists of two services:

## tsk

The project's main web server, accessible only within the Docker network.

```yaml
tsk:
  build: .
  expose:
    - "80"
```

`expose` is used so that the service is visible only to internal containers and is not directly published.

---

## nginx

Nginx is used as a reverse proxy.

```yaml
nginx:
  image: nginx:stable
  ports:
    - "80:80"
  volumes:
    - ./nginx.conf:/etc/nginx/conf.d/default.conf
```

Nginx receives incoming requests and forwards them to the `tsk` service.

---

# Nginx Reverse Proxy

Nginx configuration:

```nginx
server {
    listen 80;

    location / {
        proxy_pass http://tsk:80;
    }
}
```

Request flow:

```
Browser
   |
   v
Nginx :80
   |
   v
tsk :80
```

---

# Automation Script

The `setup.sh` file automates the project installation, verification, and execution process.

Steps:

## 1. Checking Prerequisites

Checks for and installs required tools such as:

- Python
- Curl
- Docker

---

## 2. Dockerfile Management

Before execution:

```
core/createDockerfile.py
```

Checks whether the Dockerfile exists.

If the Dockerfile is missing, it is automatically created.

---

## 3. Checking Dockerfile Changes

File:

```
core/dchange.py
```

Checks the contents of the Dockerfile.

If changes have been made:

```bash
docker compose up --build
```

is executed.

Otherwise:

```bash
docker compose up
```

is used to avoid unnecessary builds.

---

# CI Pipeline

A CI pipeline has been created for the project using GitHub Actions.

Pipeline functions:

- Triggers on `push` events
- Verifies the Dockerfile build process
- Ensures the image is built successfully

---

# How To Run

First, clone the repository:

```bash
git clone https://github.com/CAgent47/DevOpsTask.git
```

Navigate to the project directory:

```bash
cd DevOpsTask/task
```

Grant execution permissions to the script:

```bash
chmod +x setup.sh
```

Run the project:

```bash
./setup.sh
```

Once running, the service will be accessible at:

```
http://localhost
```

---

# Technologies Used

- Docker
- Docker Compose
- Nginx
- Python
- Bash
- Git
- GitHub Actions

---

# Developer

**DevOps & GitOps**

CAgent_47
Mohammad Shayegan

---

Special thanks to [NadinSoft](https://nadinsoft.com) for providing this learning and technical assessment opportunity.