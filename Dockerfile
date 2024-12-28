# Use an official NVIDIA CUDA image with cudnn8 and Ubuntu 20.04 as the base
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

# Set non-interactive installation to avoid timezone and other prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages including Miniconda
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    espeak \
    espeak-ng \
    ffmpeg \
    tk \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 \
    build-essential \
    calibre \
    && rm -rf /var/lib/apt/lists/*

RUN ebook-convert --version

# Set the working directory in the container
WORKDIR /ebook2audiobookXTTS
# Clone the ebook2audiobookXTTS repository
RUN git clone https://github.com/DrewThomasson/ebook2audiobookXTTS.git .

# Download the latest installer
ADD https://astral.sh/uv/install.sh /uv-installer.sh
# Run the installer then remove it
RUN sh /uv-installer.sh && rm /uv-installer.sh
# Ensure the installed binary is on the `PATH`
ENV PATH="/root/.local/bin/:$PATH"
# Create a virtual environment from pyproject.toml
RUN uv sync
RUN uv add pip
# activate virtual enviroment
ENV PATH="/ebook2audiobookXTTS/.venv/bin:$PATH"
