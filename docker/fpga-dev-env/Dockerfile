FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools
RUN apt-get update && apt-get install -y \
    make \
    iverilog \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# TASK automated awscli
# RUN apt-get update && apt-get install -y \
#     awscli \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# WIP rendering vcd files to png -- not the focus of the tasks right now
# RUN apt-get update && apt-get install -y \
#     gtkwave \
#     xvfb \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# RUN apt-get update && apt-get install -y \
#     python3 \
#     python3-pip \   
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*    

# # Install Python libraries for VCD parsing and plotting
# RUN pip3 install vcdvcd matplotlib

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
