# Docker Notes — Part 2: Containers, Volumes & Networking

---

## MODULE 3 — Docker Containers

---

### 3.1 What is a Container?

A **container** is a running instance of a Docker image. It is an isolated, lightweight process that has its own:
- Filesystem (from the image + writable layer)
- Process namespace (isolated PID space)
- Network interface
- Resource limits (CPU, memory)

**Container Lifecycle:**
```
 Created → Running → Paused → Running → Stopped → Deleted
             ↑                              ↓
          (restart)                    (can restart)
```

States:
| State | Description |
|---|---|
| **Created** | Container created but not started |
| **Running** | Container is executing |
| **Paused** | Processes suspended (SIGSTOP) |
| **Stopped/Exited** | Main process has stopped |
| **Dead** | Container failed to properly stop |

---

### 3.2 Running Containers — `docker run`

`docker run` = `docker create` + `docker start`

**Basic syntax:**
```bash
docker run [OPTIONS] IMAGE [COMMAND] [ARGS...]
```

**Common examples:**
```bash
# Run and remove when done
docker run --rm ubuntu echo "Hello Docker"

# Run interactively with a TTY
docker run -it ubuntu bash

# Run in detached (background) mode
docker run -d nginx

# Run with a custom name
docker run --name my-nginx -d nginx

# Run with port mapping (host:container)
docker run -d -p 8080:80 nginx

# Run with environment variables
docker run -d -e MYSQL_ROOT_PASSWORD=secret mysql:8

# Run with multiple env variables
docker run -d \
  -e DB_HOST=localhost \
  -e DB_PORT=5432 \
  -e DB_NAME=mydb \
  postgres:15

# Run with env file
docker run --env-file .env myapp

# Run with volume mount
docker run -d -v myvolume:/var/lib/mysql mysql:8

# Run with bind mount
docker run -d -v $(pwd)/html:/usr/share/nginx/html nginx

# Run with resource limits
docker run -d --memory="512m" --cpus="1.5" myapp

# Run with restart policy
docker run -d --restart=always nginx

# Run with a specific network
docker run -d --network mynetwork myapp
```

---

### 3.3 Interactive vs. Detached Mode

#### Interactive Mode (`-it`)
- `-i` — Keep STDIN open (interactive)
- `-t` — Allocate a pseudo-TTY (terminal)

```bash
docker run -it ubuntu bash
docker run -it python:3.11 python3
docker run -it node:18 node
```

#### Detached Mode (`-d`)
Runs container in the background.
```bash
docker run -d nginx
docker run -d -p 3000:3000 --name app myapp:latest
```

#### Viewing Output of Detached Container
```bash
docker logs my-container
docker logs -f my-container        # Follow (tail -f)
docker logs --tail=50 my-container # Last 50 lines
docker logs --since=1h my-container # Logs from last hour
```

---

### 3.4 Listing Containers

```bash
# List running containers
docker ps

# List ALL containers (including stopped)
docker ps -a
docker ps --all

# Show only container IDs
docker ps -q

# Show all with IDs only
docker ps -aq

# Filter containers
docker ps --filter "status=exited"
docker ps --filter "name=nginx"
docker ps --filter "label=env=production"

# Custom format
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
```

Sample `docker ps` output:
```
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                  NAMES
a1b2c3d4e5f6   nginx     "/docker-entrypoint.…"  2 minutes ago   Up 2 minutes   0.0.0.0:8080->80/tcp   my-nginx
```

---

### 3.5 Managing Container Lifecycle

```bash
# Start a stopped container
docker start my-container

# Stop a running container (sends SIGTERM, waits 10s, then SIGKILL)
docker stop my-container

# Stop with custom timeout
docker stop --time=30 my-container

# Force kill a container (sends SIGKILL immediately)
docker kill my-container

# Restart a container
docker restart my-container

# Pause a container (freeze processes)
docker pause my-container

# Unpause a container
docker unpause my-container
```

---

### 3.6 Removing Containers

```bash
# Remove a stopped container
docker rm my-container

# Force remove a running container
docker rm -f my-container

# Remove with volumes
docker rm -v my-container

# Remove all stopped containers
docker container prune

# Remove all containers (running + stopped)
docker rm -f $(docker ps -aq)

# Remove exited containers using filter
docker rm $(docker ps -q --filter "status=exited")
```

---

### 3.7 Executing Commands in Running Containers

```bash
# Run a command in a running container
docker exec my-container ls /app

# Interactive shell in running container
docker exec -it my-container bash
docker exec -it my-container sh    # If bash not available

# Run as different user
docker exec -it -u root my-container bash

# Set environment variable for exec session
docker exec -it -e DEBUG=true my-container bash

# Run in a specific working directory
docker exec -it -w /app my-container bash
```

---

### 3.8 Copying Files To/From Containers

```bash
# Copy from container to host
docker cp my-container:/app/config.json ./config.json

# Copy from host to container
docker cp ./config.json my-container:/app/config.json

# Copy entire directory
docker cp my-container:/app/logs ./local-logs
```

---

### 3.9 Container Resource Monitoring

```bash
# Real-time resource usage statistics
docker stats

# Stats for specific container
docker stats my-container

# Stats without streaming (one snapshot)
docker stats --no-stream

# Custom format
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

# Show running processes inside a container
docker top my-container

# Show detailed container info
docker inspect my-container

# Show container port mappings
docker port my-container
```

Sample `docker stats` output:
```
CONTAINER ID   NAME         CPU %   MEM USAGE / LIMIT   MEM %    NET I/O       BLOCK I/O
a1b2c3d4e5f6   my-nginx     0.02%   5.5MiB / 3.84GiB   0.14%   1.2kB / 800B  0B / 0B
```

---

### 3.10 Container Resource Limits

```bash
# Limit memory
docker run -d --memory="256m" myapp          # Max 256 MB
docker run -d --memory="1g" myapp            # Max 1 GB
docker run -d --memory-swap="512m" myapp     # Include swap

# Limit CPU
docker run -d --cpus="0.5" myapp             # Half a CPU core
docker run -d --cpus="2" myapp               # 2 CPU cores
docker run -d --cpu-shares=512 myapp         # Relative CPU weight

# Limit combined
docker run -d \
  --memory="512m" \
  --memory-reservation="256m" \
  --cpus="1" \
  myapp
```

---

### 3.11 Restart Policies

```bash
# Available policies:
# no          — Never restart (default)
# on-failure  — Restart only on non-zero exit
# always      — Always restart (except manual stop)
# unless-stopped — Always restart unless manually stopped

docker run -d --restart=no nginx
docker run -d --restart=on-failure nginx
docker run -d --restart=on-failure:5 nginx    # Max 5 retries
docker run -d --restart=always nginx
docker run -d --restart=unless-stopped nginx

# Update restart policy of existing container
docker update --restart=always my-container
```

---

### 3.12 Container Naming and Labels

```bash
# Run with a name
docker run --name web-server -d nginx

# Add labels
docker run --label env=production --label team=backend -d myapp

# Rename a container
docker rename old-name new-name
```

---

### 3.13 Inspecting Containers

```bash
# Full metadata in JSON
docker inspect my-container

# Extract specific fields with Go template
docker inspect --format='{{.State.Status}}' my-container
docker inspect --format='{{.NetworkSettings.IPAddress}}' my-container
docker inspect --format='{{.HostConfig.Memory}}' my-container
docker inspect --format='{{json .Mounts}}' my-container
```

---

### 3.14 Container Quick Reference

```bash
docker run -d --name c1 image           # Create and run
docker ps                               # List running
docker ps -a                            # List all
docker start/stop/restart c1           # Lifecycle control
docker kill c1                          # Force kill
docker rm c1                            # Remove
docker rm -f c1                         # Force remove
docker exec -it c1 bash                 # Shell access
docker logs -f c1                       # Follow logs
docker stats                            # Resource usage
docker inspect c1                       # Full details
docker cp c1:/path ./local             # Copy from container
docker cp ./file c1:/path              # Copy to container
docker top c1                           # Running processes
docker port c1                          # Port mappings
```

---

---

## MODULE 4 — Docker Volumes & Persistent Storage

---

### 4.1 The Problem with Container Storage

By default, all data written inside a container lives in the **writable container layer**, which means:
- Data is **lost** when the container is deleted.
- Data **cannot be shared** between containers.
- Writing to the container layer is slower than native disk I/O.

**Solution:** Use Docker's persistent storage mechanisms.

---

### 4.2 Types of Docker Mounts

```
Host Machine
┌────────────────────────────────────────────┐
│                                            │
│  ┌──────────┐  ┌──────────┐  ┌─────────┐  │
│  │  Volume  │  │   Bind   │  │  tmpfs  │  │
│  │ (managed │  │  Mount   │  │ (memory)│  │
│  │ by Docker│  │ (host dir│  │         │  │
│  │ /var/lib │  │ path)    │  │         │  │
│  │ /docker/ │  │          │  │         │  │
│  │ volumes) │  │          │  │         │  │
│  └────┬─────┘  └────┬─────┘  └────┬────┘  │
│       │              │              │      │
└───────┼──────────────┼──────────────┼──────┘
        │              │              │
   ┌────▼──────────────▼──────────────▼────┐
   │           Docker Container             │
   └────────────────────────────────────────┘
```

| Type | Location | Managed by | Use Case |
|---|---|---|---|
| **Volume** | `/var/lib/docker/volumes/` | Docker | Persistent data (databases) |
| **Bind Mount** | Any host path | Host OS | Development (live code reload) |
| **tmpfs** | Host RAM | Docker | Sensitive data (secrets, cache) |

---

### 4.3 Docker Volumes

Volumes are the **recommended** way to persist data.

#### Creating and Managing Volumes

```bash
# Create a named volume
docker volume create myvolume

# List volumes
docker volume ls

# Inspect a volume
docker volume inspect myvolume

# Remove a volume
docker volume rm myvolume

# Remove all unused volumes
docker volume prune

# Remove specific volumes
docker volume rm vol1 vol2 vol3
```

Sample `docker volume inspect` output:
```json
[
  {
    "Name": "myvolume",
    "Driver": "local",
    "Mountpoint": "/var/lib/docker/volumes/myvolume/_data",
    "Labels": {},
    "Scope": "local"
  }
]
```

---

#### Using Volumes in Containers

```bash
# Mount named volume (creates if doesn't exist)
docker run -d -v myvolume:/var/lib/mysql mysql:8

# Using --mount flag (more explicit, recommended)
docker run -d \
  --mount type=volume,source=myvolume,target=/var/lib/mysql \
  mysql:8

# Anonymous volume (Docker creates unnamed volume)
docker run -d -v /var/lib/mysql mysql:8

# Read-only volume
docker run -d -v myvolume:/data:ro myapp
docker run -d --mount type=volume,source=myvolume,target=/data,readonly myapp
```

---

#### Real-World Example — MySQL with Volume

```bash
# Create volume for database data
docker volume create mysql-data

# Run MySQL with persistent storage
docker run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=appdb \
  -e MYSQL_USER=appuser \
  -e MYSQL_PASSWORD=apppass \
  -v mysql-data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:8

# Data persists even if container is deleted
docker rm -f mysql-db

# Start again — data still there!
docker run -d --name mysql-db -v mysql-data:/var/lib/mysql mysql:8
```

---

### 4.4 Bind Mounts

Bind mounts link a **specific host directory or file** to the container.

```bash
# Bind mount syntax (old -v flag)
docker run -d -v /host/path:/container/path nginx
docker run -d -v $(pwd):/app node:18

# Bind mount with --mount (recommended)
docker run -d \
  --mount type=bind,source=$(pwd)/html,target=/usr/share/nginx/html \
  nginx

# Read-only bind mount
docker run -d \
  --mount type=bind,source=$(pwd)/config,target=/app/config,readonly \
  myapp

# Windows paths
docker run -d -v C:\Users\dev\app:/app node:18
```

**Use Case — Development Live Reload:**
```bash
# Mount source code into container for live development
docker run -it \
  -v $(pwd):/app \
  -w /app \
  -p 3000:3000 \
  node:18 \
  npm run dev
```

---

### 4.5 Anonymous vs. Named Volumes

```bash
# Named volume — reusable, identifiable
docker run -d -v dbdata:/var/lib/mysql mysql:8

# Anonymous volume — random name, tied to container lifecycle
docker run -d -v /var/lib/mysql mysql:8   # Volume name = random UUID

# View anonymous volumes
docker volume ls
# DRIVER    VOLUME NAME
# local     dbdata                           ← named
# local     a3f1b2c4d5e6...                  ← anonymous
```

> **Best Practice:** Use named volumes for important data. Anonymous volumes are hard to manage.

---

### 4.6 Backing Up and Restoring Volumes

```bash
# Backup a volume to a tar file
docker run --rm \
  -v myvolume:/data \
  -v $(pwd):/backup \
  ubuntu \
  tar czf /backup/myvolume-backup.tar.gz -C /data .

# Restore a volume from backup
docker run --rm \
  -v myvolume:/data \
  -v $(pwd):/backup \
  ubuntu \
  tar xzf /backup/myvolume-backup.tar.gz -C /data

# Copy data between volumes (using a helper container)
docker run --rm \
  -v source-vol:/source \
  -v dest-vol:/dest \
  ubuntu \
  cp -av /source/. /dest/
```

---

### 4.7 tmpfs Mounts

`tmpfs` stores data in the host's **RAM** — not written to disk. Data is lost when container stops. Useful for sensitive temporary data.

```bash
# Create tmpfs mount
docker run -d \
  --mount type=tmpfs,target=/tmp \
  myapp

# With size limit
docker run -d \
  --mount type=tmpfs,target=/tmp,tmpfs-size=100m \
  myapp

# Old syntax
docker run -d --tmpfs /tmp:rw,size=65536k myapp
```

---

### 4.8 Volume Summary

```bash
docker volume create vol1              # Create volume
docker volume ls                       # List volumes
docker volume inspect vol1             # Inspect volume
docker volume rm vol1                  # Remove volume
docker volume prune                    # Remove unused volumes

# In docker run:
-v vol1:/container/path                # Named volume
-v /host/path:/container/path          # Bind mount
-v /container/path                     # Anonymous volume
--mount type=volume,...                # Explicit volume mount
--mount type=bind,...                  # Explicit bind mount
--mount type=tmpfs,...                 # Explicit tmpfs mount
```

---

---

## MODULE 5 — Docker Networking

---

### 5.1 Docker Networking Fundamentals

Docker networking enables containers to communicate with each other and with external networks.

When Docker is installed, it creates three default networks:
```bash
docker network ls
# NETWORK ID     NAME      DRIVER    SCOPE
# a1b2c3d4e5f6   bridge    bridge    local
# b2c3d4e5f6a7   host      host      local
# c3d4e5f6a7b8   none      null      local
```

---

### 5.2 Network Drivers

| Driver | Description | Use Case |
|---|---|---|
| **bridge** | Default. Creates a private network on the host. | Single-host container communication |
| **host** | Container shares host's network namespace. | Max performance, no isolation |
| **none** | No networking. | Complete isolation |
| **overlay** | Multi-host networking for Swarm. | Docker Swarm |
| **macvlan** | Assigns MAC address to container. | Legacy app needing MAC addr |
| **ipvlan** | Similar to macvlan, L2/L3 control. | Network performance |

---

### 5.3 Default Bridge Network

The default `bridge` network is automatically created. Containers on default bridge can only communicate by IP address.

```bash
# Run containers on default bridge
docker run -d --name c1 nginx
docker run -d --name c2 nginx

# Get container IP
docker inspect c1 --format='{{.NetworkSettings.IPAddress}}'
# Output: 172.17.0.2

# Containers communicate by IP only (no DNS on default bridge)
docker exec c2 ping 172.17.0.2   # Works
docker exec c2 ping c1            # Does NOT work (no DNS)
```

---

### 5.4 User-Defined Bridge Networks (Recommended)

User-defined networks provide **automatic DNS resolution** by container name.

```bash
# Create a custom network
docker network create mynetwork

# Create with custom settings
docker network create \
  --driver bridge \
  --subnet 192.168.100.0/24 \
  --gateway 192.168.100.1 \
  --ip-range 192.168.100.128/25 \
  mynetwork

# Connect containers to it
docker run -d --name app --network mynetwork myapp
docker run -d --name db --network mynetwork postgres:15

# Now containers can communicate by name!
docker exec app ping db         # Works!
docker exec app curl http://db:5432   # Works!
```

---

### 5.5 Container-to-Container Communication

```bash
# Same custom network — use container names
docker network create backend
docker run -d --name api --network backend myapi
docker run -d --name database --network backend postgres:15

# api can reach database with hostname "database"
# Inside api container:
# psql -h database -U postgres

# Connect an existing container to another network
docker network connect frontend api
# Now api is on both "backend" and "frontend" networks

# Disconnect from a network
docker network disconnect frontend api
```

---

### 5.6 Port Mapping and Publishing

Containers are isolated — ports must be **explicitly published** to be accessible from the host.

```bash
# Map host port 8080 to container port 80
docker run -d -p 8080:80 nginx

# Map on specific host interface
docker run -d -p 127.0.0.1:8080:80 nginx    # Only localhost
docker run -d -p 0.0.0.0:8080:80 nginx       # All interfaces

# Map UDP port
docker run -d -p 53:53/udp dns-server

# Map multiple ports
docker run -d -p 80:80 -p 443:443 nginx

# Publish all EXPOSED ports to random host ports
docker run -d -P nginx

# View port mappings
docker port my-nginx
# 80/tcp -> 0.0.0.0:8080
```

---

### 5.7 DNS in Docker Networks

```
User-Defined Bridge Network:
  Container "app" can reach container "db" by hostname "db"

Default Bridge Network:
  Containers can only reach each other by IP address

Overlay Network (Swarm):
  Services can reach each other by service name
```

Custom DNS servers:
```bash
# Specify custom DNS for a container
docker run -d --dns=8.8.8.8 --dns=8.8.4.4 myapp

# Set DNS search domain
docker run -d --dns-search=example.com myapp
```

---

### 5.8 Creating and Managing Networks

```bash
# Create network
docker network create mynet

# Create with options
docker network create \
  --driver bridge \
  --subnet 10.10.0.0/16 \
  --gateway 10.10.0.1 \
  --opt com.docker.network.bridge.name=docker1 \
  mynet

# List networks
docker network ls

# Inspect network (shows connected containers)
docker network inspect mynet

# Connect container to network
docker network connect mynet my-container

# Disconnect container from network
docker network disconnect mynet my-container

# Remove network
docker network rm mynet

# Remove all unused networks
docker network prune
```

---

### 5.9 Host Network

```bash
# Container uses host's network stack directly (no isolation)
docker run -d --network host nginx
# nginx now listens on host's port 80 directly
# No -p flag needed (and ignored if used)
```

**Note:** Host networking only works on Linux. On Windows/macOS, containers run in a Linux VM.

---

### 5.10 None Network

```bash
# Container has no network access
docker run -d --network none myapp
# Container is completely isolated from all networks
```

---

### 5.11 Practical Networking Example

**Scenario:** Web app + API + Database with isolated networks.

```bash
# Create networks
docker network create frontend    # Web ↔ API
docker network create backend     # API ↔ DB

# Run database (only on backend network)
docker run -d \
  --name postgres \
  --network backend \
  -e POSTGRES_PASSWORD=secret \
  postgres:15

# Run API (on both networks)
docker run -d \
  --name api \
  --network backend \
  -e DB_HOST=postgres \
  myapi:latest

docker network connect frontend api

# Run web server (only on frontend network)
docker run -d \
  --name web \
  --network frontend \
  -p 80:80 \
  -e API_URL=http://api:3000 \
  myweb:latest

# Result:
# web → api → postgres (API can reach both)
# web cannot directly reach postgres (secure!)
```

---

### 5.12 Network Troubleshooting

```bash
# Check network configuration
docker network inspect mynetwork

# Check container's network settings
docker inspect container_name --format='{{json .NetworkSettings}}'

# Test connectivity between containers
docker exec myapp ping database
docker exec myapp nslookup database
docker exec myapp curl -v http://api:3000/health

# Check port binding on host
netstat -tulpn | grep docker
ss -tulpn | grep docker

# Run a utility container for debugging
docker run --rm -it --network mynetwork nicolaka/netshoot
```

---

### 5.13 Networking Quick Reference

```bash
docker network create mynet              # Create network
docker network ls                        # List networks
docker network inspect mynet            # Inspect network
docker network connect mynet c1         # Connect container
docker network disconnect mynet c1      # Disconnect container
docker network rm mynet                 # Remove network
docker network prune                    # Remove unused

# In docker run:
--network mynet                         # Attach to network
--network host                          # Use host network
--network none                          # No network
-p 8080:80                              # Publish port
-p 127.0.0.1:8080:80                    # Publish on specific interface
-P                                      # Publish all exposed ports
```

---

*End of Part 2 — Continue to Part 3: Docker Compose, Swarm, CI/CD, Security & Best Practices*
