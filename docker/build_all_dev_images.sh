#!/bin/bash

set -e

# --- Change to project root directory ---
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_ROOT" || { echo "Error: Failed to change to project root directory: $PROJECT_ROOT"; exit 1; }

# Build the base image
BASE_IMAGE_NAME="fpga-base-dev-env"
BASE_TAG="latest"
BASE_DOCKERFILE_PATH="docker/fpga-base-dev-env/Dockerfile"

echo "Building base Docker image: ${BASE_IMAGE_NAME}:${BASE_TAG}"
docker build -t ${BASE_IMAGE_NAME}:${BASE_TAG} -f ${BASE_DOCKERFILE_PATH} .

if [ $? -ne 0 ]; then
    echo "Base Docker image build failed."
    exit 1
}

echo "All development Docker images built successfully."