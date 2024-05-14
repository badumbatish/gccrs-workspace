echo "Enabling build speed up"

echo "Switching ld to lld (LLVM Linker)"

sudo rm /usr/bin/ld
sudo ln -s /usr/bin/ld.lld /usr/bin/ld