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

# Create a non-root user and group
# Using -S for system user/group to avoid creating home directories by default
# and to ensure a consistent UID/GID if not explicitly set by ARG.
# For a dev environment, a home directory is useful, so -m is kept for useradd.
RUN groupadd --system fpgauser && \
    useradd --system --create-home --gid fpgauser fpgauser

# Set the working directory
WORKDIR /app

# Ensure the non-root user owns the working directory
RUN chown -R fpgauser:fpgauser /app

# Switch to the non-root user
USER fpgauser