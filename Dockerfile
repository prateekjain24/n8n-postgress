# Use the official n8n image as base
FROM n8nio/n8n:latest

# Switch to root user to install packages
USER root

# Update package lists and install system dependencies
RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    python3-dev \
    gcc \
    ffmpeg \
    curl \
    wget \
    git \
    imagemagick \
    graphicsmagick \
    ghostscript \
    bash \
    vim \
    nano

# Create a symlink for python if needed
RUN ln -sf python3 /usr/bin/python

# Install common Python libraries for data processing and automation
RUN pip3 install --no-cache-dir \
    # Web and API libraries
    requests \
    aiohttp \
    fastapi \
    python-multipart \
    beautifulsoup4 \
    lxml \
    selenium \
    scrapy \
    # Data processing
    pandas \
    numpy \
    openpyxl \
    python-dateutil \
    pytz \
    # Image and media processing
    pillow \
    opencv-python-headless \
    # Visualization
    matplotlib \
    seaborn \
    plotly \
    # Machine learning
    scikit-learn \
    # Database connectors
    sqlalchemy \
    # Cloud services
    boto3 \
    google-cloud-storage \
    # Utilities
    pydantic \
    python-dotenv \
    schedule \
    cryptography \
    # Geographic data
    geopy \
    folium

# Install Node.js packages for additional n8n functionality
RUN npm install -g \
    pm2 \
    nodemon

# Create directories for custom nodes and configurations
RUN mkdir -p /home/node/.n8n/custom-nodes
RUN mkdir -p /home/node/.n8n/workflows
RUN mkdir -p /home/node/scripts

# Set proper permissions
RUN chown -R node:node /home/node

# Switch back to node user for security
USER node

# Set working directory
WORKDIR /home/node

# Set environment variables
ENV N8N_USER_FOLDER=/home/node/.n8n
ENV WORKFLOWS_FOLDER=/home/node/.n8n/workflows
ENV N8N_LOG_LEVEL=info
ENV NODE_ENV=production

# Expose the default n8n port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

# Start n8n
CMD ["n8n", "start"]
