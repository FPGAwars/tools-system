# Build setup script

EXT=""

if [ $ARCH == "linux_x86_64" ]; then
  CC="gcc"
  HOST="x86_64-linux-gnu"
fi

if [ $ARCH == "linux_i686" ]; then
  CC="gcc -m32"
  HOST="i686-linux-gnu"
fi

if [ $ARCH == "linux_armv7l" ]; then
  CC="arm-linux-gnueabihf-gcc"
  HOST="arm-linux-gnueabihf"
fi

if [ $ARCH == "linux_aarch64" ]; then
  CC="aarch64-linux-gnu-gcc"
  HOST="aarch64-linux-gnu"
fi






if [ $ARCH == "windows" ]; then
  EXT=".exe"
fi

if [ $ARCH == "darwin" ]; then
  J=$(($(sysctl -n hw.ncpu)-1))
else
  J=$(($(nproc)-1))
fi
