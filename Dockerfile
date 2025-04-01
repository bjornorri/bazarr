# Use an Ubuntu base image with Python 3.10
FROM ubuntu:22.04

# Use bash for the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Create a script file sourced by both interactive and non-interactive bash shells
ENV BASH_ENV /root/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

RUN apt update

# Download and install nvm
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | PROFILE="${BASH_ENV}" bash

# Set the working directory inside the container
WORKDIR /opt

# Copy project files into the container
COPY . /opt/bazarr

WORKDIR /opt/bazarr/frontend

RUN nvm install && nvm use

# Install frontend dependencies and store them.
RUN npm install
RUN mv node_modules /node_modules

# Install required system packages
RUN apt update && apt install -y \
  7zip python3-dev python3-pip python3-distutils unrar unzip ffmpeg && \
  apt clean


WORKDIR /opt/bazarr

# Install dependencies directly
RUN python3 -m pip install -r requirements.txt

# Remove bazarr. It will be mounted at runtime.
WORKDIR /opt
RUN rm -rf bazarr
COPY ./build_and_run.sh /opt/build_and_run.sh
RUN chmod +x /opt/build_and_run.sh

# Default command to run Bazarr
CMD ["/bin/bash", "/opt/build_and_run.sh"]
