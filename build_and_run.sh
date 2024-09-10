#!/bin/bash

# Set variables
IMAGE_NAME="ubuntu-22.04-nonroot"
DOCKERFILE="dockerfile-ubuntu-22.04.dockerfile"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Build the Docker image
echo "Building the Docker image..."
docker build -t $IMAGE_NAME -f $DOCKERFILE .

# Check if the build was successful
if [ $? -ne 0 ]; then
    echo "Failed to build the Docker image."
    exit 1
fi

echo "Docker image built successfully: $IMAGE_NAME"

# Run the Docker container
echo "Running the Docker container..."
# docker run -it $IMAGE_NAME
docker run -e DISPLAY=host.docker.internal:0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -it $IMAGE_NAME


# Optional: Cleanup - Uncomment to remove the image after exit
# docker rmi $IMAGE_NAME

echo "Script completed."
