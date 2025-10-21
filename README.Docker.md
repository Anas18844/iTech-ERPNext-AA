# Custom ERPNext v15 - Docker Setup

This is a custom ERPNext v15 deployment with Docker support for development and customization.

## Overview

This repository contains:
- Custom ERPNext v15 source code
- Dockerfile for building your own ERPNext image
- docker-compose.yml for orchestrating all services

## Architecture

```
┌─────────────────────────────────────────────────────┐
│  Frontend (Nginx) :8080                             │
│         ↓                                           │
│  Backend (Gunicorn + Frappe) :8000                  │
│         ↓                                           │
│  Database (MariaDB) :3306                           │
│  Redis Cache, Queue, SocketIO                       │
│  Background Workers (Queue, Scheduler)              │
│  WebSocket Server                                   │
└─────────────────────────────────────────────────────┘
```

## Prerequisites

- Docker (version 20.10 or higher)
- Docker Compose (version 2.0 or higher)
- At least 4GB RAM
- 10GB free disk space

## Quick Start

### 1. Build the Custom Image

```bash
cd /c/Users/DELL\ 5570/erpnext-v15/erpnext-version-15

# Build the custom ERPNext image
docker-compose build
```

This will:
- Use the official `frappe/erpnext:v15` as base
- Copy YOUR custom ERPNext code
- Install dependencies
- Build frontend assets
- Create image named `custom-erpnext:v15`

**Note:** First build takes 15-30 minutes depending on your internet speed.

### 2. Start All Services

```bash
# Start all services in detached mode
docker-compose up -d

# View logs
docker-compose logs -f
```

### 3. Create ERPNext Site

The `create-site` service will automatically create a site named `frontend` with:
- Admin password: `admin`
- Database root password: `admin`

Wait for the site creation to complete (check logs):
```bash
docker-compose logs -f create-site
```

### 4. Access ERPNext

Open your browser and go to:
```
http://localhost:8080
```

Login with:
- Username: `Administrator`
- Password: `admin`

## Development Workflow

### Making Changes to ERPNext Code

1. **Edit your code** in the `erpnext/` directory
2. **Rebuild the image**:
   ```bash
   docker-compose build
   ```
3. **Restart services**:
   ```bash
   docker-compose restart backend frontend
   ```

### Live Development Mode (Optional)

For faster development, you can mount your code directly into containers.

Edit `docker-compose.yml` and uncomment this line in the `backend` service:

```yaml
volumes:
  - ./erpnext:/home/frappe/frappe-bench/apps/erpnext/erpnext
```

Then restart:
```bash
docker-compose restart backend
```

Now changes to Python files will be reflected immediately (Frappe auto-reloads).

For frontend changes, rebuild assets:
```bash
docker-compose exec backend bench build --app erpnext
```

## Useful Commands

### View Running Containers
```bash
docker-compose ps
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f db
```

### Execute Commands Inside Container
```bash
# Open bash shell
docker-compose exec backend bash

# Run bench commands
docker-compose exec backend bench --site frontend migrate
docker-compose exec backend bench --site frontend clear-cache
docker-compose exec backend bench --site frontend console
```

### Stop Services
```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes data)
docker-compose down -v
```

### Rebuild After Code Changes
```bash
# Rebuild specific service
docker-compose build backend

# Rebuild all services
docker-compose build

# Rebuild without cache
docker-compose build --no-cache
```

### Database Backup
```bash
# Backup site
docker-compose exec backend bench --site frontend backup

# Backups are stored in
docker-compose exec backend ls -lh /home/frappe/frappe-bench/sites/frontend/private/backups
```

### Database Restore
```bash
# List backups
docker-compose exec backend bench --site frontend list-backups

# Restore from backup
docker-compose exec backend bench --site frontend restore [backup-file]
```

## Customization Guide

### Adding Custom Python Packages

Edit `Dockerfile` and add your packages:

```dockerfile
RUN /home/frappe/frappe-bench/env/bin/pip install \
    pandas \
    numpy \
    your-custom-package
```

### Adding System Dependencies

Edit `Dockerfile`:

```dockerfile
RUN apt-get update && apt-get install -y \
    your-system-package \
    another-package \
    && rm -rf /var/lib/apt/lists/*
```

### Adding Custom Apps

To add more Frappe apps:

1. Add the app to your project
2. Modify `Dockerfile` to install the app
3. Rebuild the image

### Changing Ports

Edit `docker-compose.yml`:

```yaml
frontend:
  ports:
    - "8080:8080"  # Change 8080 to your preferred port
```

## Troubleshooting

### Container Keeps Restarting
```bash
# Check logs
docker-compose logs -f backend

# Check container status
docker-compose ps
```

### Database Connection Issues
```bash
# Verify database is running
docker-compose ps db

# Check database logs
docker-compose logs -f db

# Test database connection
docker-compose exec db mysql -uroot -padmin
```

### Build Failures
```bash
# Clean build
docker-compose build --no-cache

# Remove old images
docker image prune -a
```

### Out of Memory
Increase Docker memory limit in Docker Desktop settings to at least 4GB.

### Permission Issues
```bash
# Fix permissions
docker-compose exec backend chown -R frappe:frappe /home/frappe/frappe-bench
```

## File Structure

```
erpnext-version-15/
├── Dockerfile              # Custom ERPNext image definition
├── docker-compose.yml      # Service orchestration
├── .dockerignore           # Files to exclude from build
├── README.Docker.md        # This file
├── erpnext/                # ERPNext Python code
├── package.json            # Node.js dependencies
├── pyproject.toml          # Python project config
└── setup.py                # Python package setup
```

## Environment Variables

You can customize behavior with environment variables in `docker-compose.yml`:

```yaml
environment:
  # Database
  DB_HOST: db
  DB_PORT: "3306"

  # Redis
  REDIS_CACHE: redis-cache:6379
  REDIS_QUEUE: redis-queue:6379

  # Custom variables
  DEVELOPER_MODE: "1"
```

## Production Deployment

For production:

1. **Change default passwords** in `docker-compose.yml`
2. **Use external database** for better performance
3. **Set up SSL/TLS** with reverse proxy (nginx/traefik)
4. **Configure backups** (automated daily backups)
5. **Use Docker secrets** for sensitive data
6. **Remove development mounts** from volumes
7. **Use production-grade settings**

Example production docker-compose snippet:
```yaml
environment:
  MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}  # Use .env file
  FRAPPE_SITE_NAME_HEADER: your-domain.com
```

## Performance Tuning

### Increase Workers
Edit `Dockerfile` gunicorn command:
```dockerfile
CMD ["gunicorn", "-w", "8", "-t", "120", ...]  # Increase workers to 8
```

### Redis Optimization
Add to redis services in `docker-compose.yml`:
```yaml
redis-cache:
  command: redis-server --maxmemory 1gb --maxmemory-policy allkeys-lru
```

## Support

- ERPNext Documentation: https://docs.erpnext.com
- Frappe Framework: https://frappeframework.com
- Community Forum: https://discuss.erpnext.com

## License

This custom ERPNext instance maintains the same license as ERPNext (GNU GPL v3).

## Author

**Anas Ahmed**
- GitHub: https://github.com/Anas18844/iTech-ERPNext-AA
