# Quick Start Guide - Custom ERPNext Docker Build

## What Changed?

You now have **YOUR OWN** custom ERPNext setup that builds from your local code!

### Before:
```
❌ Docker used frappe/erpnext:v15 (official image from Docker Hub)
❌ Your local code was ignored
❌ Changes to code didn't affect Docker
```

### After:
```
✅ Docker builds YOUR custom image from your code
✅ Your local code is packaged into the image
✅ Changes to code = rebuild image = new Docker deployment
```

## File Structure

```
erpnext-version-15/
├── Dockerfile              ← Builds YOUR custom image
├── docker-compose.yml      ← Uses YOUR custom build
├── .dockerignore           ← Optimizes build
├── README.Docker.md        ← Full documentation
├── QUICKSTART.md           ← This file
└── erpnext/                ← YOUR custom ERPNext code
```

## How It Works Now

```
Step 1: You edit code in erpnext/
   ↓
Step 2: Run: docker-compose build
   ↓
Step 3: Docker builds custom-erpnext:v15 image WITH your code
   ↓
Step 4: Run: docker-compose up -d
   ↓
Step 5: Your custom ERPNext runs with YOUR changes!
```

## Quick Commands

### First Time Setup
```bash
# Navigate to your project
cd "c:/Users/DELL 5570/erpnext-v15/erpnext-version-15"

# Build your custom image (takes 15-30 min first time)
docker-compose build

# Start all services
docker-compose up -d

# Watch the logs
docker-compose logs -f

# Wait for site creation, then access at:
# http://localhost:8080
# Username: Administrator
# Password: admin
```

### After Making Code Changes

```bash
# 1. Edit your code in erpnext/ folder

# 2. Rebuild the image
docker-compose build

# 3. Restart services
docker-compose restart backend frontend

# 4. Test your changes at http://localhost:8080
```

### Common Commands

```bash
# View running containers
docker-compose ps

# Stop everything
docker-compose down

# View logs
docker-compose logs -f backend

# Execute commands inside container
docker-compose exec backend bench --site frontend migrate
docker-compose exec backend bench --site frontend console
```

## Development Workflow

### Option 1: Rebuild After Changes (Slower but Stable)
1. Edit code
2. `docker-compose build`
3. `docker-compose restart backend`

### Option 2: Live Mount (Faster for Development)
1. Uncomment the volume mount in docker-compose.yml:
   ```yaml
   backend:
     volumes:
       - ./erpnext:/home/frappe/frappe-bench/apps/erpnext/erpnext
   ```
2. Restart: `docker-compose restart backend`
3. Now Python changes are live!
4. For frontend changes: `docker-compose exec backend bench build`

## Customization Examples

### Add Python Package
Edit [Dockerfile](Dockerfile):
```dockerfile
RUN /home/frappe/frappe-bench/env/bin/pip install pandas numpy
```
Then rebuild: `docker-compose build`

### Add Custom Doctype
1. Create your doctype in `erpnext/`
2. Rebuild: `docker-compose build`
3. Restart: `docker-compose restart backend`
4. Migrate: `docker-compose exec backend bench --site frontend migrate`

### Modify Existing Feature
1. Edit files in `erpnext/erpnext/`
2. Rebuild: `docker-compose build`
3. Restart: `docker-compose restart backend frontend`

## Next Steps

1. ✅ Code is on GitHub: https://github.com/Anas18844/iTech-ERPNext-AA
2. ✅ Docker setup is ready
3. ✅ You can make customizations

**Now you can:**
- Modify ERPNext code freely
- Build your own custom version
- Deploy with your changes
- Version control your customizations

## Troubleshooting

**Build fails?**
```bash
docker-compose build --no-cache
```

**Container won't start?**
```bash
docker-compose logs -f backend
```

**Need to reset everything?**
```bash
docker-compose down -v  # WARNING: Deletes all data!
docker-compose build
docker-compose up -d
```

## Documentation

- Full documentation: [README.Docker.md](README.Docker.md)
- ERPNext Docs: https://docs.erpnext.com
- Frappe Docs: https://frappeframework.com

## Support

Questions? Check:
1. [README.Docker.md](README.Docker.md) - Comprehensive guide
2. Docker logs: `docker-compose logs -f`
3. ERPNext Forum: https://discuss.erpnext.com

---

**Ready to customize ERPNext? Start editing code in the `erpnext/` folder!**
