# Docker Notes — Part 3: Docker Compose, Swarm, CI/CD & Security

---

## MODULE 6 — Docker Compose

---

### 6.1 What is Docker Compose?

**Docker Compose** is a tool for defining and running **multi-container** Docker applications using a YAML file.

Without Compose:
```bash
# Manual setup — tedious and error-prone
docker network create mynet
docker volume create dbdata
docker run -d --name db --network mynet -v dbdata:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret mysql:8
docker run -d --name app --network mynet -p 3000:3000 -e DB_HOST=db myapp:latest
docker run -d --name cache --network mynet redis:7
```

With Compose:
```bash
docker compose up -d    # One command, everything is up!
```

---

### 6.2 Installing Docker Compose

- **Docker Desktop** (Windows/macOS): Compose is included.
- **Linux (Compose Plugin):**

```bash
# Install Compose as Docker plugin
sudo apt-get update
sudo apt-get install docker-compose-plugin

# Verify
docker compose version
```

---

### 6.3 `docker-compose.yml` Structure

```yaml
# docker-compose.yml
version: '3.8'           # Compose file format version

services:                # Container definitions
  service_name:
    image: ...           # Use existing image
    build: ...           # Or build from Dockerfile
    ports: ...           # Port mappings
    volumes: ...         # Volume mounts
    environment: ...     # Environment variables
    networks: ...        # Networks
    depends_on: ...      # Dependencies
    restart: ...         # Restart policy

volumes:                 # Named volume definitions
  volume_name:

networks:                # Network definitions
  network_name:
```

---

### 6.4 Complete `docker-compose.yml` Example

#### Simple Web App with Database and Cache

```yaml
version: '3.8'

services:

  # Web Application
  app:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: myapp
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DB_HOST=db
      - DB_PORT=5432
      - DB_NAME=appdb
      - DB_USER=appuser
      - DB_PASSWORD=apppass
      - REDIS_HOST=cache
      - REDIS_PORT=6379
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_started
    volumes:
      - ./uploads:/app/uploads
    networks:
      - frontend
      - backend
    restart: unless-stopped

  # PostgreSQL Database
  db:
    image: postgres:15-alpine
    container_name: postgres
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: apppass
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - backend
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U appuser -d appdb"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis Cache
  cache:
    image: redis:7-alpine
    container_name: redis
    command: redis-server --requirepass cachepass
    volumes:
      - redisdata:/data
    networks:
      - backend
    restart: unless-stopped

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    container_name: nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
    depends_on:
      - app
    networks:
      - frontend
    restart: unless-stopped

volumes:
  pgdata:
    driver: local
  redisdata:
    driver: local

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true      # No external access (security)
```

---

### 6.5 Core Compose Service Options

#### `build` — Building from Dockerfile

```yaml
services:
  app:
    # Short form
    build: .

    # Long form
    build:
      context: ./app          # Build context path
      dockerfile: Dockerfile.prod
      args:
        NODE_ENV: production
        APP_VERSION: "1.2.0"
      target: production      # Multi-stage target
      cache_from:
        - myapp:latest
```

---

#### `image` — Using Pre-built Image

```yaml
services:
  db:
    image: postgres:15-alpine

  cache:
    image: redis:7

  web:
    image: registry.example.com/myapp:v1.0
```

---

#### `ports` — Port Mappings

```yaml
services:
  web:
    ports:
      - "80:80"              # host:container
      - "443:443"
      - "127.0.0.1:8080:80" # Bind to specific IP
      - "3000"               # Random host port → 3000
```

---

#### `volumes` — Mounts

```yaml
services:
  app:
    volumes:
      - myvolume:/app/data           # Named volume
      - ./src:/app/src               # Bind mount
      - ./config.json:/app/config.json:ro  # Read-only bind
      - /tmp/cache:/tmp/cache        # Absolute path bind
```

---

#### `environment` — Environment Variables

```yaml
services:
  app:
    # List form
    environment:
      - NODE_ENV=production
      - DB_HOST=db

    # Map form
    environment:
      NODE_ENV: production
      DB_HOST: db
      DB_PORT: 5432

    # Use .env file
    env_file:
      - .env
      - .env.production
```

---

#### `depends_on` — Service Dependencies

```yaml
services:
  app:
    depends_on:
      - db          # Simple: waits for container to start

      # With condition (Compose v3.9+):
      db:
        condition: service_healthy    # Wait for healthcheck to pass
      cache:
        condition: service_started    # Just wait for container to start
```

---

#### `healthcheck` — Health Monitoring

```yaml
services:
  db:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s       # Check every 10 seconds
      timeout: 5s         # Timeout per check
      retries: 5          # Fail after 5 retries
      start_period: 30s   # Grace period on startup
```

---

#### `deploy` — Resource Limits and Replicas

```yaml
services:
  app:
    deploy:
      replicas: 3
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
      restart_policy:
        condition: on-failure
        max_attempts: 3
      update_config:
        parallelism: 1
        delay: 10s
```

---

### 6.6 Core Compose Commands

```bash
# Start all services (foreground)
docker compose up

# Start in detached mode
docker compose up -d

# Build images before starting
docker compose up --build -d

# Stop and remove containers, networks
docker compose down

# Down with volumes removed
docker compose down -v

# Down with images removed
docker compose down --rmi all

# View running services
docker compose ps

# View logs
docker compose logs
docker compose logs -f          # Follow
docker compose logs -f app      # Specific service
docker compose logs --tail=50 app

# Execute command in a running service
docker compose exec app bash
docker compose exec db psql -U postgres

# Run a one-off command (new container)
docker compose run app python manage.py migrate
docker compose run --rm app npm run tests

# Build images
docker compose build
docker compose build app        # Specific service

# Pull images
docker compose pull

# Scale a service
docker compose up -d --scale app=3

# Restart services
docker compose restart
docker compose restart app

# Stop services (without removing)
docker compose stop

# Start stopped services
docker compose start

# View configuration (merged YAML)
docker compose config

# List images used
docker compose images

# Remove stopped service containers
docker compose rm
```

---

### 6.7 Environment Variables in Compose

**`.env` file (auto-loaded from project root):**
```env
# .env
COMPOSE_PROJECT_NAME=myapp
DB_PASSWORD=secretpassword
APP_PORT=3000
POSTGRES_VERSION=15
```

**Referencing in `docker-compose.yml`:**
```yaml
version: '3.8'
services:
  db:
    image: postgres:${POSTGRES_VERSION:-15}
    ports:
      - "${APP_PORT:-3000}:5432"
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
```

**Shell environment variables** (override `.env`):
```bash
export DB_PASSWORD=mypass
docker compose up -d
```

**Compose `.env` vs container `environment`:**
- `.env` → substituted into `docker-compose.yml` (Compose-level)
- `environment:` → passed into the container

---

### 6.8 Multi-File Compose Override

```bash
# Base configuration
docker-compose.yml

# Override for development
docker-compose.override.yml      # Auto-loaded

# Override for production
docker-compose.prod.yml          # Manual

# Merge multiple files
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

**`docker-compose.yml` (base):**
```yaml
services:
  app:
    image: myapp:latest
    environment:
      - NODE_ENV=production
```

**`docker-compose.override.yml` (dev — auto-merged):**
```yaml
services:
  app:
    build: .
    volumes:
      - .:/app              # Live code reload
    environment:
      - NODE_ENV=development
    ports:
      - "9229:9229"         # Debug port
```

---

### 6.9 Real-World Project Example — WordPress

```yaml
version: '3.8'

services:
  wordpress:
    image: wordpress:latest
    container_name: wordpress
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: mysql
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppass
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress_data:/var/www/html
    depends_on:
      mysql:
        condition: service_healthy
    restart: unless-stopped

  mysql:
    image: mysql:8.0
    container_name: mysql
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: wppass
      MYSQL_ROOT_PASSWORD: rootpass
    volumes:
      - mysql_data:/var/lib/mysql
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

  phpmyadmin:
    image: phpmyadmin:latest
    container_name: phpmyadmin
    ports:
      - "8080:80"
    environment:
      PMA_HOST: mysql
      PMA_USER: wpuser
      PMA_PASSWORD: wppass
    depends_on:
      - mysql

volumes:
  wordpress_data:
  mysql_data:
```

---

---

## MODULE 7 — Docker Registries

---

### 7.1 Public vs. Private Registries

| Registry | Type | Notes |
|---|---|---|
| **Docker Hub** | Public/Private | Default registry, free tier |
| **GitHub Container Registry (GHCR)** | Public/Private | Integrated with GitHub |
| **Amazon ECR** | Private | AWS-native |
| **Google Artifact Registry** | Private | GCP-native |
| **Azure Container Registry (ACR)** | Private | Azure-native |
| **Harbor** | Self-hosted | Open source, enterprise |
| **Local Registry** | Self-hosted | For private/air-gapped |

---

### 7.2 Docker Hub

```bash
# Login
docker login

# Login with credentials
docker login -u username -p password

# Push to Docker Hub
docker tag myapp:latest username/myapp:1.0
docker push username/myapp:1.0

# Pull from Docker Hub
docker pull username/myapp:1.0

# Logout
docker logout
```

---

### 7.3 Running a Private Registry

```bash
# Run local Docker registry
docker run -d \
  --name registry \
  -p 5000:5000 \
  -v registry-data:/var/lib/registry \
  registry:2

# Tag and push to local registry
docker tag myapp:latest localhost:5000/myapp:1.0
docker push localhost:5000/myapp:1.0

# Pull from local registry
docker pull localhost:5000/myapp:1.0

# List images in local registry
curl http://localhost:5000/v2/_catalog
```

---

### 7.4 GitHub Container Registry (GHCR)

```bash
# Login with GitHub token
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Tag and push
docker tag myapp:latest ghcr.io/username/myapp:1.0
docker push ghcr.io/username/myapp:1.0

# Pull
docker pull ghcr.io/username/myapp:1.0
```

---

---

## MODULE 8 — Docker in CI/CD Pipelines

---

### 8.1 Role of Docker in CI/CD

Docker makes CI/CD pipelines:
- **Reproducible:** Same environment every time
- **Portable:** Runs on any CI platform
- **Fast:** Layer caching speeds up builds
- **Isolated:** Tests don't interfere with each other

---

### 8.2 GitHub Actions with Docker

```yaml
# .github/workflows/docker.yml
name: Build and Push Docker Image

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            username/myapp:latest
            username/myapp:${{ github.sha }}
          cache-from: type=gistry,ref=username/myapp:buildcache
          cache-to: type=registry,ref=username/myapp:buildcache,mode=max

  test:
    runs-on: ubuntu-latest
    needs: build

    steps:
      - name: Run tests in container
        run: |
          docker run --rm username/myapp:${{ github.sha }} npm test
```

---

### 8.3 GitLab CI with Docker

```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - deploy

variables:
  IMAGE_TAG: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

build:
  stage: build
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $IMAGE_TAG .
    - docker push $IMAGE_TAG

test:
  stage: test
  script:
    - docker run --rm $IMAGE_TAG npm test

deploy:
  stage: deploy
  only:
    - main
  script:
    - docker pull $IMAGE_TAG
    - docker tag $IMAGE_TAG $CI_REGISTRY_IMAGE:latest
    - docker push $CI_REGISTRY_IMAGE:latest
```

---

---

## MODULE 9 — Docker Swarm

---

### 9.1 What is Container Orchestration?

As applications scale, manual container management becomes impossible. **Orchestration tools** automate:
- Deploying containers across multiple hosts
- Scaling up/down
- Load balancing
- Health monitoring and self-healing
- Rolling updates

**Docker Swarm** is Docker's built-in orchestration tool.
**Kubernetes** is the industry-standard (more complex, more features).

---

### 9.2 Docker Swarm Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Docker Swarm                         │
│                                                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Manager 1  │  │   Manager 2  │  │   Manager 3  │  │
│  │  (Leader)    │  │  (Follower)  │  │  (Follower)  │  │
│  └──────┬───────┘  └──────────────┘  └──────────────┘  │
│         │                                                │
│  ┌──────▼──────────────────────────────────────────┐   │
│  │                  Worker Nodes                    │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐       │   │
│  │  │  Worker  │  │  Worker  │  │  Worker  │       │   │
│  │  │  Node 1  │  │  Node 2  │  │  Node 3  │       │   │
│  │  └──────────┘  └──────────┘  └──────────┘       │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

| Role | Description |
|---|---|
| **Manager Node** | Manages cluster state, schedules tasks, provides API |
| **Worker Node** | Runs tasks (containers) assigned by manager |
| **Leader** | Single manager handling scheduling decisions |

---

### 9.3 Initializing a Swarm

```bash
# Initialize swarm (current machine becomes manager)
docker swarm init

# Initialize with specific IP
docker swarm init --advertise-addr 192.168.1.100

# Get token for adding workers
docker swarm join-token worker

# Get token for adding managers
docker swarm join-token manager

# Join as worker (run on worker node)
docker swarm join --token SWMTKN-1-xxxxx 192.168.1.100:2377

# Join as manager
docker swarm join --token SWMTKN-1-yyyyy 192.168.1.100:2377

# List nodes
docker node ls

# Inspect a node
docker node inspect node-id

# Leave swarm (run on node to remove)
docker swarm leave
docker swarm leave --force   # On manager
```

---

### 9.4 Docker Services

In Swarm, you don't run containers directly — you create **services**. A service is a task definition that Swarm distributes across the cluster.

```bash
# Create a service
docker service create --name web nginx

# Create with replicas and port
docker service create \
  --name web \
  --replicas 3 \
  --publish 80:80 \
  nginx

# Create with constraints (run only on worker nodes)
docker service create \
  --name web \
  --replicas 3 \
  --constraint "node.role==worker" \
  nginx

# List services
docker service ls

# Inspect a service
docker service inspect web
docker service inspect --pretty web

# See service tasks (where containers are running)
docker service ps web

# Scale a service
docker service scale web=5
docker service scale web=2 api=4

# Update service (rolling update)
docker service update \
  --image nginx:1.25 \
  --update-parallelism 1 \
  --update-delay 10s \
  web

# Rollback to previous version
docker service rollback web

# Remove a service
docker service rm web
```

---

### 9.5 Docker Stacks

**Stacks** deploy multi-service applications to Swarm using a Compose file.

```bash
# Deploy stack from Compose file
docker stack deploy -c docker-compose.yml myapp

# List stacks
docker stack ls

# List services in a stack
docker stack services myapp

# List tasks in a stack
docker stack ps myapp

# Remove a stack
docker stack rm myapp
```

**Compose file for Swarm (stack-specific options):**
```yaml
version: '3.8'

services:
  web:
    image: myapp:1.0
    ports:
      - "80:80"
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
        failure_action: rollback
      restart_policy:
        condition: on-failure
      placement:
        constraints:
          - "node.role==worker"

  db:
    image: postgres:15
    deploy:
      placement:
        constraints:
          - "node.role==manager"   # DB only on manager
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
```

---

### 9.6 Swarm Secrets

Swarm secrets securely store sensitive data (passwords, tokens, certificates).

```bash
# Create secret from string
echo "mysecretpassword" | docker secret create db_password -

# Create secret from file
docker secret create ssl_cert ./cert.pem

# List secrets
docker secret ls

# Inspect secret (cannot see value)
docker secret inspect db_password

# Use secret in a service
docker service create \
  --name myapp \
  --secret db_password \
  myapp:latest

# Remove secret
docker secret rm db_password
```

In container, secrets are available at `/run/secrets/<secret_name>`:
```bash
cat /run/secrets/db_password
```

In `docker-compose.yml` for Swarm:
```yaml
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password
    secrets:
      - db_password

secrets:
  db_password:
    external: true    # Must be created beforehand with docker secret create
```

---

---

## MODULE 10 — Docker Security & Best Practices

---

### 10.1 Docker Security Model

Docker provides isolation using Linux kernel features:
- **Namespaces:** Isolate PID, network, filesystem, users
- **cgroups:** Limit CPU, memory, disk I/O
- **Capabilities:** Fine-grained privilege control
- **Seccomp:** Restrict system calls
- **AppArmor/SELinux:** Mandatory access control

**Threat model:**
- Compromised container should not affect host
- Containers should not access other containers' data
- Images should not contain vulnerabilities or secrets

---

### 10.2 Run as Non-Root User

By default, containers run as **root** — a security risk. Always use a non-root user.

```dockerfile
# Create a user in Dockerfile
FROM node:18-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app
COPY --chown=appuser:appgroup . .
RUN npm ci --only=production

USER appuser
CMD ["node", "server.js"]
```

```bash
# Verify container is not running as root
docker run --rm myapp whoami
# appuser

# Run existing container as specific user
docker run -u 1001:1001 myapp
```

---

### 10.3 Read-Only Filesystem

```bash
# Run with read-only root filesystem
docker run --read-only myapp

# Allow writing to specific paths
docker run \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /var/run \
  -v /data \
  myapp
```

---

### 10.4 Drop Linux Capabilities

Linux capabilities are fine-grained root privileges. Drop unnecessary ones.

```bash
# Drop ALL capabilities, add only what's needed
docker run \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \   # Allow binding to ports < 1024
  nginx

# Common capabilities to drop:
# NET_RAW, SYS_ADMIN, SYS_PTRACE, SYS_MODULE, DAC_OVERRIDE
```

Available capabilities: `CAP_NET_BIND_SERVICE`, `CAP_CHOWN`, `CAP_SETUID`, `CAP_SETGID`, `CAP_KILL`, `CAP_NET_RAW`, etc.

---

### 10.5 Seccomp Profiles

Restrict system calls a container can make.

```bash
# Use default seccomp profile (Docker applies by default)
docker run --security-opt seccomp=/path/to/seccomp.json myapp

# Disable seccomp (not recommended)
docker run --security-opt seccomp=unconfined myapp
```

---

### 10.6 No New Privileges

Prevent processes from gaining new privileges via setuid/setgid.

```bash
docker run --security-opt no-new-privileges:true myapp
```

---

### 10.7 Image Scanning for Vulnerabilities

```bash
# Docker Scout (built-in)
docker scout quickview myapp:latest
docker scout cves myapp:latest

# Trivy (open source scanner)
trivy image myapp:latest
trivy image --severity HIGH,CRITICAL myapp:latest

# Snyk
snyk container test myapp:latest
```

---

### 10.8 Dockerfile Security Best Practices

```dockerfile
# 1. Use specific versions (not latest)
FROM node:18.20.2-alpine3.19   # Pinned version

# 2. Use minimal base images
FROM alpine:3.19          # Minimal
FROM distroless/nodejs18  # Google distroless (even more minimal)

# 3. Multi-stage to exclude build tools
FROM node:18 AS builder
RUN npm ci && npm run build

FROM node:18-alpine AS production
COPY --from=builder /app/dist ./dist
# Build tools are NOT in final image

# 4. Run as non-root
RUN adduser -D appuser
USER appuser

# 5. Don't copy sensitive files
# Use .dockerignore:
#   .env
#   .env.*
#   secrets/
#   *.pem
#   *.key

# 6. Avoid hardcoding secrets
ENV DB_PASSWORD=secret    # BAD — visible in docker history

# Use build args or runtime env:
ARG DB_PASSWORD           # OK for build time only
ENV DB_PASSWORD=${DB_PASSWORD}

# 7. COPY instead of ADD
COPY . .   # Not ADD

# 8. Pin package versions
RUN pip install flask==3.0.2 gunicorn==22.0.0

# 9. Verify checksums
RUN wget -O /tmp/app.tar.gz https://example.com/app.tar.gz && \
    echo "abc123def456  /tmp/app.tar.gz" | sha256sum -c && \
    tar xzf /tmp/app.tar.gz
```

---

### 10.9 `.dockerignore` Best Practices

```
# Version control
.git
.gitignore
.github

# Dependencies (re-installed in image)
node_modules
vendor/
__pycache__

# Secrets and environment
.env
.env.*
*.pem
*.key
*.crt
secrets/

# Development files
*.log
*.tmp
.DS_Store
Thumbs.db

# Documentation
README.md
docs/

# CI/CD
.travis.yml
Jenkinsfile
.gitlab-ci.yml

# Editor files
.vscode
.idea
*.swp
```

---

### 10.10 Minimize Image Size

```dockerfile
# Use Alpine Linux base (~5 MB vs ~100 MB for full Ubuntu)
FROM python:3.11-alpine   # ~50 MB vs python:3.11 ~1 GB

# Use slim variants
FROM python:3.11-slim     # Debian slim
FROM node:18-slim

# Use distroless (no shell, no package manager — most secure)
FROM gcr.io/distroless/nodejs18-debian12

# Clean up in same RUN layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
    && make app \
    && apt-get purge -y --auto-remove build-essential \
    && rm -rf /var/lib/apt/lists/*

# Only install production dependencies
RUN npm ci --only=production

# Multi-stage builds
FROM golang:1.21 AS builder
RUN CGO_ENABLED=0 go build -o /app .

FROM scratch
COPY --from=builder /app /app
```

---

### 10.11 Docker Content Trust (Image Signing)

```bash
# Enable content trust (verify image signatures)
export DOCKER_CONTENT_TRUST=1

# Sign and push image
docker trust sign username/myapp:1.0
docker push username/myapp:1.0

# Verify image signature
docker trust inspect --pretty username/myapp:1.0

# Disable for specific operation
DOCKER_CONTENT_TRUST=0 docker pull untrusted-image:latest
```

---

### 10.12 Monitoring Docker Containers

#### Docker native monitoring:
```bash
# Real-time stats
docker stats

# Container events
docker events

# System usage
docker system df
```

#### cAdvisor + Prometheus + Grafana Stack:

```yaml
# docker-compose.monitoring.yml
version: '3.8'

services:
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker:/var/lib/docker:ro
    ports:
      - "8080:8080"

  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    depends_on:
      - prometheus

volumes:
  prometheus_data:
  grafana_data:
```

---

### 10.13 System Cleanup Commands

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune
docker image prune -a        # All unused (not just dangling)

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Remove everything unused at once
docker system prune

# Remove everything including volumes (DANGEROUS)
docker system prune -a --volumes

# Show disk usage
docker system df
docker system df -v          # Verbose

# Remove specific resources
docker rm $(docker ps -aq)              # All containers
docker rmi $(docker images -q)          # All images
docker volume rm $(docker volume ls -q) # All volumes
```

---

### 10.14 Production Deployment Checklist

- [ ] Use specific image tags (not `latest`)
- [ ] Multi-stage build for minimal image size
- [ ] Non-root user in container
- [ ] Read-only filesystem where possible
- [ ] Drop unnecessary capabilities (`--cap-drop=ALL`)
- [ ] Set memory and CPU limits
- [ ] Use `--restart=unless-stopped` or `always`
- [ ] Health checks defined
- [ ] Secrets via Docker Secrets or env vars (not hardcoded)
- [ ] No sensitive data in image layers (`docker history`)
- [ ] `.dockerignore` excludes secrets and dev files
- [ ] Image scanned for vulnerabilities
- [ ] Logging configured (log driver: json-file with rotation)
- [ ] Network policies: internal networks for backend services
- [ ] Regular image updates for security patches
- [ ] Use `no-new-privileges` security option
- [ ] Image signed with Docker Content Trust

---

### 10.15 Logging Configuration

```bash
# Configure log driver
docker run -d \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  nginx

# Other log drivers: syslog, journald, gelf, fluentd, awslogs, splunk
docker run -d --log-driver syslog nginx
docker run -d --log-driver fluentd nginx

# Set default log driver in daemon.json
# /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

---

### 10.16 Docker Daemon Configuration

**`/etc/docker/daemon.json`:**
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "max-concurrent-downloads": 5,
  "max-concurrent-uploads": 5,
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 64000,
      "Soft": 64000
    }
  },
  "live-restore": true,
  "userland-proxy": false,
  "no-new-privileges": true,
  "dns": ["8.8.8.8", "8.8.4.4"]
}
```

Restart daemon after changes:
```bash
sudo systemctl restart docker
```

---

---

## Quick Reference — All Essential Commands

### Images
```bash
docker pull image:tag              docker build -t name:tag .
docker images                      docker rmi image
docker inspect image               docker history image
docker tag src dst                 docker push image
docker save -o file.tar image      docker load -i file.tar
```

### Containers
```bash
docker run [options] image         docker ps / docker ps -a
docker start/stop/restart name     docker rm / docker rm -f name
docker exec -it name bash          docker logs -f name
docker inspect name                docker stats
docker cp name:/path ./local       docker top name
docker kill name                   docker rename old new
```

### Volumes
```bash
docker volume create vol           docker volume ls
docker volume inspect vol          docker volume rm vol
docker volume prune                -v vol:/path (in docker run)
```

### Networks
```bash
docker network create net          docker network ls
docker network inspect net         docker network connect net c1
docker network disconnect net c1   docker network rm net
docker network prune
```

### Compose
```bash
docker compose up -d               docker compose down [-v]
docker compose ps                  docker compose logs -f
docker compose exec svc bash       docker compose build
docker compose pull                docker compose restart
docker compose scale svc=3         docker compose config
```

### Swarm
```bash
docker swarm init                  docker swarm join --token ...
docker node ls                     docker service create ...
docker service ls                  docker service ps svc
docker service scale svc=n         docker service update ...
docker service rollback svc        docker stack deploy -c file.yml app
docker stack ls                    docker stack rm app
docker secret create name -        docker secret ls
```

### System
```bash
docker system df                   docker system prune
docker system prune -a --volumes   docker events
docker info                        docker version
```

---

*End of Part 3 — Docker Notes Complete*

---

## Summary of All Modules

| Module | Topics |
|---|---|
| **1** | Virtualization, Docker Architecture, Installation |
| **2** | Images, Dockerfile, Build, Tag, Push, Multi-stage |
| **3** | Containers, Lifecycle, Exec, Logs, Resources |
| **4** | Volumes, Bind Mounts, tmpfs, Backup/Restore |
| **5** | Networking, Bridge, Overlay, Port Mapping, DNS |
| **6** | Docker Compose, YAML syntax, Compose commands |
| **7** | Registries, Docker Hub, GHCR, Private Registry |
| **8** | CI/CD, GitHub Actions, GitLab CI |
| **9** | Docker Swarm, Services, Stacks, Secrets |
| **10** | Security, Non-root, Image Scanning, Best Practices |
