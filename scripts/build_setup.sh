#!/bin/bash
# Build setup script

if [ "$ARCH" == "linux_x86_64" ]; then
  export CC="gcc"
  export HOST="x86_64-linux-gnu"
fi

if [ "$ARCH" == "linux_i686" ]; then
  export CC="gcc -m32"
  export HOST="i686-linux-gnu"
  export CONFIG_FLAGS="CFLAGS=-m32 CXXFLAGS=-m32 LDFLAGS=-m32"
  export CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-m32.cmake"
fi

if [ "$ARCH" == "linux_armv7l" ]; then
  export CC="arm-linux-gnueabihf-gcc"
  export HOST="arm-linux-gnueabihf"
  export CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-armhf.cmake"
fi

if [ "$ARCH" == "linux_aarch64" ]; then
  export CC="aarch64-linux-gnu-gcc"
  export HOST="aarch64-linux-gnu"
  export CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-aarch64.cmake"
fi

if [ "$ARCH" == "windows_x86" ]; then
  export EXE=".exe"
  export CC="i686-w64-mingw32-gcc"
  export HOST="i686-w64-mingw32"
  export CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-win32.cmake"
fi

if [ "$ARCH" == "windows_amd64" ]; then
  export EXE=".exe"
  export CC="x86_64-w64-mingw32-gcc"
  export HOST="x86_64-w64-mingw32"
  export CMAKE_FLAGS="-DCMAKE_TOOLCHAIN_FILE=$WORK_DIR/build-data/cmake/toolchain-win64.cmake"
fi

if [ "$ARCH" == "darwin" ]; then
  export CC="clang"
  export J=$(($(sysctl -n hw.ncpu)-1))
else
  #support for 1cpu machines
  J=$(nproc)
  export J
  if [ "$J" -gt 1 ]; then
	  export J=$(($(nproc)-1))
  fi
fi
