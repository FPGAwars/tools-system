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

if [ $ARCH == "windows_x86" ]; then
  EXT=".exe"
  CC="i686-w64-mingw32-gcc"
  HOST="i686-w64-mingw32"
fi

if [ $ARCH == "windows_amd64" ]; then
  EXT=".exe"
  CC="x86_64-w64-mingw32-gcc"
  HOST="x86_64-w64-mingw32"
fi


if [ $ARCH == "darwin" ]; then
  J=$(($(sysctl -n hw.ncpu)-1))
else
  J=$(($(nproc)-1))
fi
