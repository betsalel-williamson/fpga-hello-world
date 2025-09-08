FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools
RUN apt-get update && apt-get install -y \
    iverilog \
    gtkwave \
    git \
    awscli \
    make \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
ARG USER_NAME=fpgauser
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USER_NAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USER_NAME

WORKDIR /app

# Switch to the non-root user
USER $USER_NAME
