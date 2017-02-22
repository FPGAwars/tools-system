# Install dependencies script

if [ $ARCH == "linux_x86_64" ]; then
  sudo apt-get install -y build-essential
  sudo apt-get autoremove -y
fi

if [ $ARCH == "linux_i686" ]; then
  sudo apt-get install -y build-essential gcc-multilib g++-multilib
  sudo apt-get autoremove -y
fi

if [ $ARCH == "linux_armv7l" ]; then
  sudo apt-get install -y build-essential gcc-arm-linux-gnueabihf \
                          g++-arm-linux-gnueabihf
  sudo apt-get autoremove -y
fi

if [ $ARCH == "linux_aarch64" ]; then
  sudo apt-get install -y build-essential gcc-aarch64-linux-gnu \
                          g++-aarch64-linux-gnu
  sudo apt-get autoremove -y
fi

if [ $ARCH == "windows" ]; then
  sudo apt-get install -y build-essential mingw-w64
  sudo apt-get autoremove -y
fi

if [ $ARCH == "darwin" ]; then
  brew install wget libusb libftdi
fi
