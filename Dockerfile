FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Tapedrive (adjust this based on how tapedrive is installed)
# You'll need to replace this with the actual installation method
RUN curl -sSL https://your-tapedrive-install-url | bash
# OR if it's a binary download:
# RUN wget -O /usr/local/bin/tapedrive https://releases.tapedrive.com/tapedrive && chmod +x /usr/local/bin/tapedrive

# Create working directory
WORKDIR /app

# Copy any necessary configuration files
# COPY config/ ./config/

# Create a startup script
RUN echo '#!/bin/bash\n\
# Start archive in background\n\
tapedrive archive &\n\
\n\
# Start mining\n\
tapedrive mine G7ebQDVo96tGMsLAYkw93MR3czaTpQdoiUwPPFZJm4e8\n\
' > /app/start.sh && chmod +x /app/start.sh

# Expose any necessary ports (adjust as needed)
# EXPOSE 8080

CMD ["/app/start.sh"]
