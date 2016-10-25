# Install dependencies script

if [ $ARCH == "linux_x86_64" ]; then
  sudo apt-get install -y build-essential
  sudo apt-get autoremove -y
fi

if [ $ARCH == "linux_i686" ]; then
  sudo apt-get install -y build-essential gcc-multilib g++-multilib \
                          libftdi1-dev:i386
  sudo apt-get autoremove -y
fi

if [ $ARCH == "linux_armv7l" ]; then
  sudo apt-get install -y build-essential bison flex gperf libtool autoconf \
                          gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf qemu
  sudo apt-get autoremove -y
fi

if [ $ARCH == "linux_aarch64" ]; then
  sudo apt-get install -y build-essential bison flex gperf libtool autoconf \
                          gcc-aarch64-linux-gnu g++-aarch64-linux-gnu qemu
  sudo apt-get autoremove -y
fi

if [ $ARCH == "darwin" ]; then
  brew install bison
fi

if [ $ARCH == "windows" ]; then
  sudo apt-get install -y build-essential bison flex gperf libtool autoconf \
                          mingw-w64 mingw-w64-tools zip
  sudo apt-get autoremove -y
fi
