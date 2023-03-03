# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# Enable non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update -y \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:git-core/ppa \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    curl \
    ca-certificates \
    dnsutils \
    ftp \
    git \
    git-lfs \
    iproute2 \
    iputils-ping \
    iptables \
    jq \
    locales \
    netcat \
    net-tools \
    openssh-client \
    python3-pip \
    rsync \
    shellcheck \
    sudo \
    telnet \
    time \
    tzdata \
    unzip \
    upx \
    wget \
    zip \
    zstd \
    vim \
    && ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip

RUN adduser --disabled-password --gecos "" --uid 1000 glich \
    && usermod -aG sudo glich \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

USER glich

# Install homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/glich/.bashrc

# Install starship with --yes option
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes && \
    echo 'eval "$(starship init bash)"' >> /home/glich/.bashrc && \
    mkdir -p /home/glich/.config

# Add starship.toml
COPY <<-EOT /home/glich/.config/starship.toml
format = """
[┌───────────────────>](bold red) https://glich.stream
[│](bold red)\$directory\$rust\$package
[└─>](bold red) """
EOT

ENV HOME=/home/glich

WORKDIR /home/glich