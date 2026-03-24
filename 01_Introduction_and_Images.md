# Docker Notes — Part 1: Introduction & Docker Images

---

## MODULE 1 — Introduction to Containerization & Docker

---

### 1.1 What is Virtualization? VMs vs. Containers

#### Traditional Virtualization (Virtual Machines)

Before containers, developers used **Virtual Machines (VMs)** to isolate applications. A VM runs a complete OS on top of a **Hypervisor** (e.g., VMware, VirtualBox, Hyper-V).

```
┌────────────────────────────────────────────┐
│               Application A                │
│               Application B                │
├───────────────┬────────────────────────────┤
│   Guest OS 1  │       Guest OS 2           │
├───────────────┴────────────────────────────┤
│              Hypervisor                    │
├────────────────────────────────────────────┤
│              Host OS                       │
├────────────────────────────────────────────┤
│              Hardware                      │
└────────────────────────────────────────────┘
```

**Problems with VMs:**
- Each VM requires a full OS (GBs of space).
- Slow to boot (minutes).
- High resource overhead.
- Hard to scale quickly.

---

#### Containerization

Containers share the **host OS kernel** and isolate only the application and its dependencies using **namespaces** and **cgroups**.

```
┌──────────────┬──────────────┬──────────────┐
│  Container A │  Container B │  Container C │
│  (App + Libs)│  (App + Libs)│  (App + Libs)│
├──────────────┴──────────────┴──────────────┤
│              Docker Engine (Runtime)        │
├────────────────────────────────────────────┤
│              Host OS (Shared Kernel)        │
├────────────────────────────────────────────┤
│              Hardware                       │
└────────────────────────────────────────────┘
```

**Advantages of Containers:**
- Lightweight (MBs instead of GBs).
- Start in milliseconds.
- Consistent environment: "works on my machine" problem solved.
- Portable across cloud providers and local machines.
- Highly efficient — can run hundreds on a single host.

---

#### VM vs. Container — Comparison Table

| Feature | Virtual Machine | Container |
|---|---|---|
| OS | Full guest OS per VM | Shared host OS kernel |
| Size | GBs | MBs |
| Boot time | Minutes | Milliseconds |
| Isolation | Strong (hardware-level) | Process-level |
| Performance | Overhead | Near-native |
| Portability | Limited | High |
| Use case | Full OS isolation | App isolation |

---

### 1.2 What is Docker?

**Docker** is an open-source platform that enables developers to **build, package, ship, and run** applications in containers.

- Created by **Solomon Hykes** at dotCloud in 2013.
- Written in **Go (Golang)**.
- Uses Linux kernel features: **namespaces**, **cgroups**, **union file systems**.
- The most widely used container platform in the world.

**Key Benefits:**
- **Consistency:** Same environment in dev, test, and production.
- **Speed:** Rapid deployment and scaling.
- **Isolation:** Applications don't interfere with each other.
- **Efficiency:** Better resource utilization than VMs.
- **Ecosystem:** Huge library of pre-built images on Docker Hub.

---

### 1.3 Docker Architecture

Docker uses a **Client-Server architecture**.

```
┌─────────────┐         REST API / Unix Socket
│ Docker CLI  │ ──────────────────────────────────►  ┌──────────────────────┐
│  (Client)   │                                       │   Docker Daemon      │
└─────────────┘                                       │   (dockerd)          │
                                                      │                      │
                                                      │  ┌────────────────┐  │
                                                      │  │   Containers   │  │
                                                      │  ├────────────────┤  │
                                                      │  │    Images      │  │
                                                      │  ├────────────────┤  │
                                                      │  │    Volumes     │  │
                                                      │  ├────────────────┤  │
                                                      │  │   Networks     │  │
                                                      │  └────────────────┘  │
                                                      └──────────┬───────────┘
                                                                 │
                                                      ┌──────────▼───────────┐
                                                      │   Docker Registry    │
                                                      │   (Docker Hub, etc.) │
                                                      └──────────────────────┘
```

#### Components:

| Component | Description |
|---|---|
| **Docker Client** | CLI tool (`docker`) that sends commands to the daemon |
| **Docker Daemon** (`dockerd`) | Background service that manages containers, images, networks, volumes |
| **Docker Registry** | Storage for Docker images (Docker Hub is the default public registry) |
| **containerd** | Low-level container runtime used by Docker |
| **runc** | OCI-compliant container runtime that actually creates containers |

---

### 1.4 Core Docker Components

| Component | Description |
|---|---|
| **Image** | Read-only template used to create containers. Like a class in OOP. |
| **Container** | A running instance of an image. Like an object in OOP. |
| **Volume** | Persistent storage that survives container lifecycle. |
| **Network** | Virtual network for container communication. |
| **Dockerfile** | Text file with instructions to build an image. |
| **Registry** | Repository for storing and distributing images. |

---

### 1.5 Installing Docker

#### Windows
1. Download Docker Desktop from https://www.docker.com/products/docker-desktop
2. Requires WSL 2 backend (Windows Subsystem for Linux).
3. Enable virtualization in BIOS.
4. Install and restart.

#### macOS
1. Download Docker Desktop for Mac (Intel or Apple Silicon).
2. Install the `.dmg` file.
3. Start Docker Desktop.

#### Linux (Ubuntu/Debian)
```bash
# Remove old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install prerequisites
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release

# Add Docker's GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Enable Docker to start on boot
sudo systemctl enable docker
sudo systemctl start docker

# Run Docker without sudo (add user to docker group)
sudo usermod -aG docker $USER
newgrp docker
```

---

### 1.6 Verifying Installation

```bash
# Check Docker version
docker version

# Check system-wide Docker info
docker info

# Run a test container
docker run hello-world
```

**Sample output of `docker version`:**
```
Client: Docker Engine - Community
 Version:           25.0.0
 API version:       1.44
 Go version:        go1.21.4

Server: Docker Engine - Community
 Engine:
  Version:          25.0.0
  API version:      1.44 (minimum version 1.12)
```

---

### 1.7 Your First Container

```bash
docker run hello-world
```

What happens step-by-step:
1. Docker client contacts the Docker daemon.
2. Daemon checks if `hello-world` image exists locally.
3. If not, daemon pulls image from Docker Hub.
4. Daemon creates a new container from the image.
5. Container runs, prints message, then exits.

```bash
# Run Ubuntu container interactively
docker run -it ubuntu bash

# Inside the container
ls
cat /etc/os-release
exit
```

---

---

## MODULE 2 — Docker Images

---

### 2.1 What is a Docker Image?

A Docker Image is a **read-only, layered file system** used as a template for creating containers.

- Composed of **stacked layers** (each instruction in Dockerfile = one layer).
- Layers are **shared** between images — saves disk space.
- Images are **immutable** — once built, they don't change.
- The container adds a thin **read-write layer** on top.

```
┌─────────────────────────────┐  ← Read/Write Layer (Container)
├─────────────────────────────┤
│   Layer 4: App code (COPY)  │
├─────────────────────────────┤
│   Layer 3: npm install (RUN)│
├─────────────────────────────┤
│   Layer 2: node:18 base     │
├─────────────────────────────┤
│   Layer 1: Ubuntu base OS   │
└─────────────────────────────┘  ← Read-Only (Image)
```

---

### 2.2 Docker Hub and Registries

**Docker Hub** (https://hub.docker.com) is the default public registry.

Image naming convention:
```
[registry/][username/]image_name[:tag]

Examples:
  ubuntu                          → Official Ubuntu image, latest tag
  ubuntu:22.04                    → Specific version
  nginx:alpine                    → Nginx on Alpine Linux
  myusername/myapp:v1.0           → User's custom image
  gcr.io/google-containers/pause  → Google Container Registry image
```

---

### 2.3 Pulling Images

```bash
# Pull latest Ubuntu
docker pull ubuntu

# Pull specific version
docker pull ubuntu:22.04

# Pull from Docker Hub explicitly
docker pull docker.io/library/nginx:latest

# Pull from another registry
docker pull gcr.io/google-containers/pause:3.9
```

---

### 2.4 Listing and Inspecting Images

```bash
# List all local images
docker images
docker image ls

# List images with all details
docker images -a

# Show image IDs only
docker images -q

# Inspect detailed image metadata
docker inspect ubuntu:22.04

# Show image history/layers
docker history nginx:latest

# Show image disk usage
docker system df
```

Sample `docker images` output:
```
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
ubuntu        22.04     a8780b506fa4   2 weeks ago    77.9MB
nginx         latest    e4720093a3c1   3 weeks ago    187MB
hello-world   latest    d2c94e258dcb   1 year ago     13.3kB
```

---

### 2.5 Introduction to Dockerfile

A **Dockerfile** is a plain-text script containing instructions to build a Docker image.

```
Dockerfile  →  docker build  →  Docker Image  →  docker run  →  Container
```

**Basic Dockerfile Example:**
```dockerfile
# Base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Start command
CMD ["node", "server.js"]
```

---

### 2.6 Core Dockerfile Instructions

#### FROM
Defines the base image. Every Dockerfile must start with FROM.
```dockerfile
FROM ubuntu:22.04
FROM node:18-alpine
FROM scratch          # Empty base image (for static binaries)
FROM python:3.11-slim
```

---

#### RUN
Executes commands during the **build** phase (creates a new layer).
```dockerfile
# Shell form
RUN apt-get update && apt-get install -y curl git

# Exec form (recommended)
RUN ["apt-get", "install", "-y", "curl"]

# Best practice: chain commands to minimize layers
RUN apt-get update && \
    apt-get install -y curl git vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

---

#### COPY vs ADD
Both copy files from host to image.
```dockerfile
# COPY — simple and preferred
COPY source.txt /app/destination.txt
COPY ./src /app/src
COPY package*.json /app/

# ADD — has extra features (auto-extract tar, download URLs) — use only when needed
ADD archive.tar.gz /app/       # Auto-extracts
ADD https://example.com/file.txt /app/  # Downloads from URL
```

> **Best Practice:** Use `COPY` by default. Use `ADD` only for tar extraction.

---

#### CMD
Defines the **default command** when a container starts. Can be overridden.
```dockerfile
CMD ["node", "app.js"]          # Exec form (preferred)
CMD node app.js                 # Shell form
CMD ["python", "-m", "http.server", "8080"]
```

---

#### ENTRYPOINT
Sets the **main executable** of the container. Harder to override.
```dockerfile
ENTRYPOINT ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["python3"]
```

**CMD vs ENTRYPOINT:**
| | CMD | ENTRYPOINT |
|---|---|---|
| Purpose | Default command/arguments | Main executable |
| Override | Easily overridden with `docker run <cmd>` | Requires `--entrypoint` flag |
| Combined use | CMD provides default args to ENTRYPOINT | ENTRYPOINT is the fixed command |

```dockerfile
# Combined example
ENTRYPOINT ["python3"]
CMD ["app.py"]           # Default: python3 app.py
                         # Override: docker run image script.py → python3 script.py
```

---

#### ENV
Sets environment variables available at build and runtime.
```dockerfile
ENV NODE_ENV=production
ENV PORT=3000
ENV APP_HOME=/app DB_HOST=localhost
```

Access in container:
```bash
echo $NODE_ENV   # production
```

---

#### EXPOSE
Documents the port the container listens on (informational only — does not actually publish).
```dockerfile
EXPOSE 80
EXPOSE 3000
EXPOSE 5432/tcp
EXPOSE 53/udp
```

To actually publish: `docker run -p 8080:80 nginx`

---

#### WORKDIR
Sets the working directory for subsequent RUN, CMD, ENTRYPOINT, COPY, ADD instructions.
```dockerfile
WORKDIR /app
WORKDIR /usr/src/app
```

Creates directory if it doesn't exist. Preferred over `RUN cd /app`.

---

#### ARG
Defines build-time variables (only available during build, not at runtime).
```dockerfile
ARG VERSION=1.0
ARG NODE_ENV=production

RUN echo "Building version $VERSION"
```

Pass at build time:
```bash
docker build --build-arg VERSION=2.0 .
```

---

#### LABEL
Adds metadata to the image.
```dockerfile
LABEL maintainer="you@example.com"
LABEL version="1.0"
LABEL description="My Application"
LABEL org.opencontainers.image.source="https://github.com/user/repo"
```

---

#### USER
Sets the user for subsequent instructions and container runtime.
```dockerfile
# Create user and switch to it
RUN useradd -r -s /bin/false appuser
USER appuser

# Use numeric UID/GID (more secure)
USER 1001:1001
```

---

#### VOLUME
Creates a mount point / declares that a path should be externally mounted.
```dockerfile
VOLUME ["/data"]
VOLUME /var/log
```

---

#### HEALTHCHECK
Defines how Docker tests if a container is healthy.
```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

HEALTHCHECK NONE    # Disable inherited healthcheck
```

---

#### ONBUILD
Triggers an instruction when the image is used as a base.
```dockerfile
ONBUILD COPY . /app/src
ONBUILD RUN npm install
```

---

#### STOPSIGNAL
Sets the signal to stop the container.
```dockerfile
STOPSIGNAL SIGTERM
STOPSIGNAL 9
```

---

### 2.7 Building Images

```bash
# Build from Dockerfile in current directory
docker build .

# Build with a tag (name:version)
docker build -t myapp:1.0 .

# Build from a specific Dockerfile path
docker build -f path/to/Dockerfile .

# Build with build arguments
docker build --build-arg ENV=production -t myapp .

# Build with no cache (fresh build)
docker build --no-cache -t myapp .

# Show build progress verbosely
docker build --progress=plain -t myapp .
```

---

### 2.8 Image Tagging

```bash
# Tag an existing image
docker tag myapp:latest myapp:1.0.0

# Tag for Docker Hub push
docker tag myapp:1.0 username/myapp:1.0

# Tag for private registry
docker tag myapp:1.0 registry.example.com:5000/myapp:1.0
```

---

### 2.9 Pushing Images

```bash
# Login to Docker Hub
docker login

# Login to private registry
docker login registry.example.com:5000

# Push to Docker Hub
docker push username/myapp:1.0

# Push to private registry
docker push registry.example.com:5000/myapp:1.0
```

---

### 2.10 Removing Images

```bash
# Remove a specific image
docker rmi ubuntu:22.04
docker image rm nginx

# Remove image by ID
docker rmi a8780b506fa4

# Force remove (even if containers exist)
docker rmi -f myapp:old

# Remove all dangling (untagged) images
docker image prune

# Remove all unused images (dangling + unreferenced)
docker image prune -a

# Remove all images (careful!)
docker rmi $(docker images -q)
```

---

### 2.11 Multi-Stage Builds

Multi-stage builds allow you to use multiple `FROM` instructions in a single Dockerfile, reducing final image size by copying only what's needed.

**Without multi-stage (large image):**
```dockerfile
FROM node:18
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
CMD ["node", "dist/server.js"]
# Includes: Node.js, npm, source code, dev dependencies — ~1 GB
```

**With multi-stage (small image):**
```dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine AS production
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node", "dist/server.js"]
# Only production artifacts — ~150 MB
```

**Another example — Go binary:**
```dockerfile
# Build stage
FROM golang:1.21 AS builder
WORKDIR /src
COPY . .
RUN go build -o /app/server .

# Final stage
FROM scratch
COPY --from=builder /app/server /server
ENTRYPOINT ["/server"]
# Size: just the binary — ~10 MB
```

---

### 2.12 Image Caching and Layer Optimization

Docker caches each layer. If a layer hasn't changed, Docker reuses the cache.

**Rules for cache invalidation:**
- If a layer changes, all subsequent layers are rebuilt.
- `COPY` invalidates cache if any copied file changes.
- `RUN` invalidates cache only if the command string changes.

**Optimization: Copy dependency files first**
```dockerfile
# BAD — code changes invalidate npm install layer
FROM node:18
WORKDIR /app
COPY . .                    # All files — code change = reinstall
RUN npm install
CMD ["node", "server.js"]

# GOOD — separate dependency and code layers
FROM node:18
WORKDIR /app
COPY package*.json ./       # Only package files
RUN npm install             # Cached unless package.json changes
COPY . .                    # Copy code (only this layer invalidated on code change)
CMD ["node", "server.js"]
```

**More optimization tips:**
```dockerfile
# Minimize layers — chain RUN commands
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

# Use .dockerignore to exclude unnecessary files
# (like .git, node_modules, *.log)
```

**`.dockerignore` file:**
```
.git
.gitignore
node_modules
npm-debug.log
*.log
.env
.DS_Store
README.md
Dockerfile
.dockerignore
```

---

### 2.13 Complete Dockerfile Example — Python Flask App

```dockerfile
FROM python:3.11-slim

# Metadata
LABEL maintainer="dev@example.com"
LABEL version="1.0"

# Environment
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy application
COPY . .

# Create non-root user
RUN useradd -r -s /bin/false flaskuser
USER flaskuser

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Start command
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:application"]
```

---

### 2.14 Useful Image Commands — Quick Reference

```bash
docker images                         # List all images
docker pull <image>                   # Pull image from registry
docker build -t <name:tag> .          # Build image
docker tag <image> <new-name:tag>     # Tag image
docker push <image>                   # Push to registry
docker rmi <image>                    # Remove image
docker inspect <image>                # Detailed metadata
docker history <image>                # Show layers
docker image prune                    # Remove dangling images
docker image prune -a                 # Remove all unused images
docker save -o file.tar <image>       # Export image to tar
docker load -i file.tar               # Import image from tar
```

---

*End of Part 1 — Continue to Part 2: Containers, Volumes & Networking*
