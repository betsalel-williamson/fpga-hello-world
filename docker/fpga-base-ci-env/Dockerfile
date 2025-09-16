FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install common dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install necessary tools for SystemVerilog
RUN apt-get update && apt-get install -y \
    verilator \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install necessary tools for Verilog
RUN apt-get update && apt-get install -y \
    iverilog \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install necessary tools for VHDL
RUN apt-get update && apt-get install -y \
    ghdl-gcc \
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

# Install mise for the fpgauser
RUN curl https://mise.run | sh

# Set mise environment variables and update PATH for fpgauser
ENV MISE_DATA_DIR=/home/fpgauser/.mise/data
ENV MISE_CONFIG_DIR=/home/fpgauser/.mise/config
ENV MISE_CACHE_DIR=/home/fpgauser/.mise/cache
ENV PATH="/home/fpgauser/.local/bin:/home/fpgauser/.mise/shims:${PATH}"

# Install Python dependencies using mise
RUN mise use uv@latest && \
    mise exec -- uv venv && \
    mise exec -- uv pip install vsg
ENV PATH="/app/.venv/bin:${PATH}"
