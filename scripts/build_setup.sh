# Build setup script

if [ $ARCH == "linux_x86_64" ]; then
  CC="gcc"
  HOST="x86_64-linux-gnu"
fi

if [ $ARCH == "linux_i686" ]; then
  CC="gcc -m32"
  HOST="i686-linux-gnu"
  CONFIG_FLAGS="CFLAGS=-m32 CXXFLAGS=-m32 LDFLAGS=-m32"
  CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-m32.cmake"
fi

if [ $ARCH == "linux_armv6l" ]; then
  CC="arm-linux-gnueabihf-gcc -marm -march=armv6"
  HOST="arm-linux-gnueabihf"
  CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-armhf.cmake"
fi

if [ $ARCH == "linux_armv7l" ]; then
  CC="arm-linux-gnueabihf-gcc"
  HOST="arm-linux-gnueabihf"
  CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-armhf.cmake"
fi

if [ $ARCH == "linux_aarch64" ]; then
  CC="aarch64-linux-gnu-gcc"
  HOST="aarch64-linux-gnu"
  CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-aarch64.cmake"
fi

if [ $ARCH == "windows_x86" ]; then
  EXE=".exe"
  CC="i686-w64-mingw32-gcc"
  HOST="i686-w64-mingw32"
  CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-win32.cmake"
fi

if [ $ARCH == "windows_amd64" ]; then
  EXE=".exe"
  CC="x86_64-w64-mingw32-gcc"
  HOST="x86_64-w64-mingw32"
  CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-win64.cmake"
fi

if [ $ARCH == "darwin" ]; then
  CC="clang"
  J=$(($(sysctl -n hw.ncpu)-1))
else
  J=$(($(nproc)-1))
fi
