# Custom ERPNext v15 Docker Image
# Base image with Frappe Framework
FROM frappe/erpnext:v15 as base

# Maintainer information
LABEL maintainer="Anas Ahmed <your-email@example.com>"
LABEL description="Custom ERPNext v15 with customizations"

# Switch to root for installations
USER root

# Install any additional system dependencies you might need
# Example: Additional Python packages, system libraries, etc.
RUN apt-get update && apt-get install -y \
    vim \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Switch back to frappe user
USER frappe

# Set working directory
WORKDIR /home/frappe/frappe-bench

# Copy your custom ERPNext code
# This replaces the default ERPNext with your version
COPY --chown=frappe:frappe . /home/frappe/frappe-bench/apps/erpnext

# Install/Update Python dependencies from your custom code
RUN cd /home/frappe/frappe-bench/apps/erpnext && \
    /home/frappe/frappe-bench/env/bin/pip install --no-cache-dir -e .

# Install/Update Node dependencies if you have custom frontend code
RUN cd /home/frappe/frappe-bench/apps/erpnext && \
    yarn install --frozen-lockfile || true

# Build frontend assets
RUN cd /home/frappe/frappe-bench && \
    /home/frappe/frappe-bench/env/bin/bench build --app erpnext || true

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8000/api/method/ping || exit 1

# Expose ports
EXPOSE 8000 9000

# Default command (will be overridden by docker-compose)
CMD ["gunicorn", "-b", "0.0.0.0:8000", "-t", "120", "-w", "4", "--worker-class", "gthread", "--threads", "2", "frappe.app:application", "--preload"]
