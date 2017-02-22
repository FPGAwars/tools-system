# -- Compile lsftdi script

VER=1.2
LIBFTDI1=libftdi1-$VER
TAR_LIBFTDI1=$LIBFTDI1.tar.bz2
REL_LIBFTDI1=https://www.intra2net.com/en/developer/libftdi/download/$TAR_LIBFTDI1

VER=1.0.20
LIBUSB=libusb-$VER

# -- Setup
. $WORK_DIR/scripts/build_setup.sh

cd $UPSTREAM_DIR

# -- Check and download the release
test -e $TAR_LIBFTDI1 || wget $REL_LIBFTDI1

# -- Unpack the release
tar jxf $TAR_LIBFTDI1

# -- Copy the upstream sources into the build directory
rsync -a $LIBFTDI1 $BUILD_DIR --exclude .git

cd $BUILD_DIR/$LIBFTDI1

PREFIX=$BUILD_DIR/$LIBFTDI1/release
LIBUSB_PREFIX=$BUILD_DIR/$LIBUSB/release


#-- Build libftdi
mkdir -p build
cd build
export PKG_CONFIG_PATH=$LIBUSB_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH
cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX
make -j$J
make install
cd ..

#-- Build lsftdi
cd examples
  $CC -o lsftdi find_all.c -static -lftdi1 -lusb-1.0 -lpthread -L$PREFIX/lib -L$LIBUSB_PREFIX/lib -I$PREFIX/include/libftdi1
cd ..


if [ $ARCH == "linux_i686" ]; then
  gcc -m32 -o lsftdi find_all.c -lftdi1 -lusb-1.0 -lpthread -I ../src -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "linux_armv7l" ]; then
  arm-linux-gnueabihf-gcc -o lsftdi find_all.c -lftdi1 -lusb-1.0 -lpthread -I ../src -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "linux_aarch64" ]; then
  aarch64-linux-gnu-gcc -o lsftdi find_all.c -lftdi1 -lusb-1.0 -lpthread -I ../src -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "windows" ]; then
  i686-w64-mingw32-gcc -o lsftdi find_all.c -lftdi1 -lusb-1.0 -lpthread -I ../src -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "darwin" ]; then
  clang -o lsftdi find_all.c -lftdi1 -lusb-1.0
fi



# -- Test the generated executables
if [ $ARCH != "darwin" ]; then
  test_bin examples/lsftdi
fi

# -- Copy the executable into the packages/bin dir
cp examples/lsftdi $PACKAGE_DIR/$NAME/bin/lsftdi$EXE
