# ERPNext v15 Docker Image
# Use official Frappe ERPNext image
FROM frappe/erpnext:v15

# Maintainer information
LABEL maintainer="Anas Ahmed <your-email@example.com>"
LABEL description="ERPNext v15"

# Set environment variables
ENV PYTHONUNBUFFERED=1
