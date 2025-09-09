#!/bin/bash

IMAGE_NAME="vhdl-dev-env"
TAG="latest"
DOCKERFILE_PATH="Dockerfile"

echo "Building Docker image: ${IMAGE_NAME}:${TAG}"
docker build -t ${IMAGE_NAME}:${TAG} -f ${DOCKERFILE_PATH} .

if [ $? -eq 0 ]; then
    echo "Docker image built successfully. Testing GHDL installation..."
    docker run --rm ${IMAGE_NAME}:${TAG} ghdl --version
    if [ $? -eq 0 ]; then
        echo "GHDL test passed. Image ${IMAGE_NAME}:${TAG} is ready."
        exit 0
    else
        echo "GHDL test failed. Check Dockerfile and GHDL installation within the image."
        exit 1
    fi
else
    echo "Docker image build failed."
    exit 1
fi
