# Use the official Ubuntu 22.04 image from Docker Hub
FROM ubuntu:20.04

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

# Install ros1 noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add - && \
    apt update

RUN apt install -y ros-noetic-desktop-full


# Installing GUI applications to be interfacing with XQuartz
RUN apt update && \
    apt install -y x11-apps  # Installs basic X11 applications like xclock and xeyes && \
    apt install -y firefox   # Example: Install Firefox


# Installing pip 
RUN apt update && \
    apt install -y python3-pip

# Installing swig, library for converting C files to other language (needed for ydlidar python api)
RUN apt-get install -y python swig



# Installing ydlidar-sdk
RUN cd /home && \
    git clone https://github.com/YDLIDAR/YDLidar-SDK.git && \
    cd YDLidar-SDK/ && \
    mkdir build && \ 

    cd build && \
    cmake .. && \
    make && \
    sudo make install

# Building ydlidar python library
RUN cd /home/YDLidar-SDK && \
    python3 setup.py build && \
    python3 setup.py install

# Installing tmux
RUN apt install -y tmux


# Installing rosdep
RUN apt-get install -y python3-rosdep

# Installing catkin
RUN apt install -y python3-catkin-tools

# Install VNC services
# RUN apt-get update && \
#     apt-get install -y tightvncserver xfce4 xfce4-goodies && \
#     tightvncserver :1


# RUN source /opt/ros/humble/setup.bash

# Set the default command to bash
CMD ["/bin/bash"]
