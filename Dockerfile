FROM ubuntu:22.04

# Set timezone (important for some packages) 
ARG TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV HOME=/home/workspace

RUN yes | unminimize

# Install packages (break this up into checkpoints if you're having build issues)
# Apt caching from: https://stackoverflow.com/a/72851168
# TODO: could probably remove some of these packages
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
  --mount=target=/var/cache/apt,type=cache,sharing=locked \
  rm -f /etc/apt/apt.conf.d/docker-clean \
  &&  apt-get update \
  && apt-get install -y \
  binutils \
  cgdb \
  clang \
  clang-format \
  cmake \
  curl \
  exuberant-ctags \
  g++ \
  gcc \
  gdb \
  gdb-multiarch \
  git \
  libxrandr-dev \
  libncurses5-dev \
  silversearcher-ag \
  tmux \
  vim \
  valgrind \
  autoconf \
  wget \
  python3 \
  python3-pip \
  python3-git \
  python-is-python3 \
  sudo \
  fzf \
  openssh-server \
  man \
  file \
  rsync \
  libglib2.0-dev \
  zsh \
  fish \
  build-essential libgmp3-dev libmpfr-dev libmpc-dev flex bison autogen dejagnu \
  cargo \ 
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Dependencies for git customization
RUN pip install requests unidiff
RUN useradd --create-home --home-dir /home/workspace --user-group workspace && echo workspace:workspace | chpasswd \
  && chsh -s /bin/bash workspace && echo "workspace ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /home/workspace
COPY "./home/*" ./

# RUN git config --global init.defaultBranch main


# COPY ./install_scripts/. /install_scripts
# WORKDIR /install_scripts
# RUN ./create_group0.sh && ./create_student0.sh && ./install_bochs.sh && ./install_rust.sh && ./squish/install.sh

WORKDIR /
COPY entrypoint.sh .

RUN chown -R workspace:workspace /home/workspace

RUN mv /home/workspace /workspace

USER workspace

ENTRYPOINT [ "/entrypoint.sh" ]
