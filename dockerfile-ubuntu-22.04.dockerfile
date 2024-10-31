# Use the official Ubuntu 22.04 image from Docker Hub
FROM ubuntu:22.04

# Set environment variables to avoid interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install basic utilities
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    curl \
    wget \
    vim \
    git \
    sudo \
    build-essential \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Installing python 3.8
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y python3.8 python3.8-venv python3.8-distutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add ROS 2 GPG key and repository
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Update and install ROS 2 Humble
RUN apt-get update && apt-get install -y ros-humble-desktop && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt update && apt install -y python3-colcon-common-extensions

# Installing GUI applications to be interfacing with XQuartz
RUN apt update && \
    apt install -y x11-apps  # Installs basic X11 applications like xclock and xeyes && \
    apt install -y firefox   # Example: Install Firefox

# Installing tmux
RUN apt install tmux

# Install gazebo and turtlebot
RUN apt update && apt install -y ros-humble-gazebo-ros-pkgs ros-humble-gazebo-ros && \
    apt install -y ros-humble-turtlebot3*


RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc 

# Set the default command to bash
CMD ["/bin/bash"]
