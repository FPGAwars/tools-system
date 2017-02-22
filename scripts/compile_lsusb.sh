# -- Compile lsusb script

VER=1.0.20
LIBUSB=libusb-$VER
TAR_LIBUSB=$LIBUSB.tar.bz2
REL_LIBUSB=https://github.com/libusb/libusb/releases/download/v1.0.20/$TAR_LIBUSB

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Check and download the release
test -e $TAR_LIBUSB || wget $REL_LIBUSB

# -- Unpack the release
tar jxf $TAR_LIBUSB

# -- Copy the upstream sources into the build directory
rsync -a $LIBUSB $BUILD_DIR --exclude .git

cd $BUILD_DIR/$LIBUSB

PREFIX=$BUILD_DIR/$LIBUSB/release

#-- Build libusb

./configure --host=$HOST --prefix=$PREFIX --enable-udev=no
make -j$J
make install

#-- Build static lsusb

cd examples
$CC -o lsusb listdevs.c -static -lusb-1.0 -lpthread -L$PREFIX/lib -I$PREFIX/include/libusb-1.0
cd ..


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
  i686-w64-mingw32-gcc -o lsusb listdevs.c -lusb-1.0 -lpthread -I ../libusb -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "darwin" ]; then
  clang -o lsusb listdevs.c -lusb-1.0 -I ../libusb
fi

# -- Test the generated executables
if [ $ARCH != "darwin" ]; then
  test_bin examples/lsusb
fi

# -- Copy the executable into the packages/bin dir
cp examples/lsusb $PACKAGE_DIR/$NAME/bin/lsusb$EXE
