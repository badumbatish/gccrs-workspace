#!/bin/bash

set -e

SRC=/workspace

sudo service ssh start

echo "Docker workspace is ready!"
echo "Entry directory is $(pwd)"

echo "CD-ing into ${SRC}"
cd ${SRC}
echo "Current directory is $(pwd)"

if [ -f .clang-format ]; then
    echo ".clang-format already exists locally."
else
    echo "Downloading .clang-format..."
    curl -s https://github.com/Rust-GCC/gccrs/raw/master/contrib/clang-format -o .clang-format
fi

if [ -f .vimrc ]; then
    echo ".vimrc already exists locally."
else
    echo "Downloading .vimrc..."
    curl -s https://github.com/Rust-GCC/gccrs/raw/master/contrib/vimrc -o .vimrc
fi

/bin/bash
