FROM ubuntu:22.04

# Set timezone (important for some packages) 
ARG TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV HOME=/home

RUN yes | unminimize

# Install packages (break this up into checkpoints if you're having build issues)
# Apt caching from: https://stackoverflow.com/a/72851168
# TODO: could probably remove some of these packages
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
  --mount=target=/var/cache/apt,type=cache,sharing=locked \
  rm -f /etc/apt/apt.conf.d/docker-clean \
  &&  apt-get update \
  # Add newest git version
  && add-apt-repository ppa:git-core/ppa 

# TERMINAL UTILITIES
RUN apt-get install -y \
  curl \
  tmux \
  vim \
  wget \
  sudo \
  fzf \
  openssh-server \
  man \
  file \
  rsync 
  
# SHELL FLAVORS
RUN apt-get install -y \
  zsh \
  fish 

# RUST DEPENDENCIES
RUN apt-get instlal -y \
  cargo 

# PYTHON DEPENDENCIES
RUN apt-get install -y \
  python3 \
  python3-pip \
  python3-git \
  python-is-python3 


# C/C++ DEPENDENCIES 
RUN apt-get install -y \
  binutils \
  cgdb \
  clang \
  clang-format \
  cmake \
  exuberant-ctags \
  g++ \
  gcc \
  gdb \
  gdb-multiarch \
  git \
  silversearcher-ag \
  valgrind \
  autoconf \
  libglib2.0-dev \
  build-essential libgmp3-dev libmpfr-dev libmpc-dev flex bison autogen dejagnu

# CLEAN UP APT GET CACHE
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# GIT CUSTOMIZATION DEPENDENCIES
RUN pip install requests unidiff


RUN useradd --create-home --home-dir /home/workspace --user-group workspace && echo workspace:workspace | chpasswd \
  && chsh -s /bin/bash workspace && echo "workspace ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR ${HOME}
COPY "./home/*" ./

# COPY ./install_scripts/. /install_scripts
# WORKDIR /install_scripts
# RUN ./create_group0.sh && ./create_student0.sh && ./install_bochs.sh && ./install_rust.sh && ./squish/install.sh

WORKDIR /
COPY entrypoint.sh .

RUN chown -R workspace:workspace ${HOME}

USER workspace

ENTRYPOINT [ "/entrypoint.sh" ]
