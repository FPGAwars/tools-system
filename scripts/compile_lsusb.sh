# -- Compile lsusb script

LSUSB=libusb-1.0.20
REL_LSUSB=https://github.com/libusb/libusb/releases/download/v1.0.20/$LSUSB.tar.bz2

EXT=""
if [ $ARCH == "windows" ]; then
  EXT=".exe"
fi

if [ $ARCH == "darwin" ]; then
  J=$(($(sysctl -n hw.ncpu)-1))
else
  J=$(($(nproc)-1))
fi

cd $UPSTREAM_DIR

# -- Check and download the release
test -e $LSUSB.tar.bz2 || wget $REL_LSUSB

# -- Unpack the release
tar vjxf $LSUSB.tar.bz2

# -- Copy the upstream sources into the build directory
rsync -a $LSUSB $BUILD_DIR --exclude .git

cd $BUILD_DIR/$LSUSB

#-- Build static lsusb

cd examples

if [ $ARCH == "linux_x86_64" ]; then
  gcc -o lsusb listdevs.c -lusb-1.0 -lpthread -I ../libusb -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "linux_i686" ]; then
  gcc -m32 -o lsusb listdevs.c -lusb-1.0 -lpthread -I ../libusb -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "linux_armv7l" ]; then
  arm-linux-gnueabihf-gcc -o lsusb listdevs.c -lusb-1.0 -lpthread -I ../libusb -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "linux_aarch64" ]; then
  aarch64-linux-gnu-gcc -o lsusb listdevs.c -lusb-1.0 -lpthread -I ../libusb -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "windows" ]; then
  i686-w64-mingw32-gcc -o lsusb.exe listdevs.c -lusb-1.0 -lpthread -I ../libusb -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "darwin" ]; then
  clang -o lsusb listdevs.c -lusb-1.0 -I ../libusb
fi

cd ..

# -- Test the generated executables
if [ $ARCH != "darwin" ]; then
  test_bin examples/lsusb$EXT
fi

# -- Copy the executable into the packages/bin dir
mkdir -p $PACKAGE_DIR/$NAME/bin
cp examples/lsusb$EXT $PACKAGE_DIR/$NAME/bin
