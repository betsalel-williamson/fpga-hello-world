FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools
RUN apt-get update && apt-get install -y \
    iverilog \
    gtkwave \
    git \
    awscli \
    make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group with a common UID/GID for GitHub Actions runners
# GitHub Actions runner often uses UID 1001.
RUN groupadd --system --gid 1001 fpgauser && \
    useradd --system --create-home --uid 1001 --gid 1001 fpgauser

# Set the working directory
WORKDIR /app

# Ensure the non-root user owns the working directory
# This is important if /app is a mounted volume from the host
RUN chown -R fpgauser:fpgauser /app

# Switch to the non-root user
USER fpgauser
