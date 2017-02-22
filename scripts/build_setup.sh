# Build setup script

EXT=""

if [ $ARCH == "linux_x86_64" ]; then
  CC=gcc
  HOST=x86_64-linux-gnu
fi









if [ $ARCH == "windows" ]; then
  EXT=".exe"
fi

if [ $ARCH == "darwin" ]; then
  J=$(($(sysctl -n hw.ncpu)-1))
else
  J=$(($(nproc)-1))
fi
