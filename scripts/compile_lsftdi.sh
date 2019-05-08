# -- Compile lsftdi script

VER=1.4
LIBFTDI1=libftdi1-$VER
TAR_LIBFTDI1=$LIBFTDI1.tar.bz2
REL_LIBFTDI1=https://www.intra2net.com/en/developer/libftdi/download/$TAR_LIBFTDI1

VER=1.0.22
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
LIBCONFUSE_VER=3.2.2
LIBCONFUSE=confuse-$LIBCONFUSE_VER

#-- Build libftdi
if [ $ARCH != "darwin" ]; then
  mkdir -p build
  cd build
  export PKG_CONFIG_PATH=$LIBUSB_PREFIX/lib/pkgconfig
  cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX $CMAKE_FLAGS
  make -j$J
  make install
  cd ..
fi

#-- Build lsftdi
cd examples
if [ $ARCH == "darwin" ]; then
    $CC -o lsftdi find_all.c -lftdi1 -lusb-1.0  -I../src
else
    $CC -o lsftdi find_all.c -static -lftdi1  -lusb-1.0 -lpthread -L$PREFIX/lib -L$LIBUSB_PREFIX/lib -I$PREFIX/include/libftdi1
    $CC -o ../release/bin/ftdi_eeprom ../ftdi_eeprom/main.c -static -lftdi1  -lusb-1.0 -lconfuse -lpthread -I../../../../build-data/includes -L$PREFIX/lib -L$LIBUSB_PREFIX/lib -I$LIBUSB_PREFIX/include/libusb-1.0 -I$PREFIX/include/libftdi1  -L$BUILD_DIR/$LIBCONFUSE/release/lib -I$BUILD_DIR/$LIBCONFUSE/release/include
fi
cd ..

# -- Test the generated executables
if [ $ARCH != "darwin" ]; then

    test_bin examples/lsftdi$EXE
    test_bin release/bin/ftdi_eeprom$EXE

    if [ $ARCH != "windows_x86" ] && [ $ARCH != "windows_amd64" ]; then
        test_bin release/bin/libftdi1-config
    fi
fi

# -- Copy the executable into the packages/bin dir
cp examples/lsftdi$EXE $PACKAGE_DIR/$NAME/bin/lsftdi$EXE
cp release/bin/ftdi_eeprom$EXE $PACKAGE_DIR/$NAME/bin/ftdi_eeprom$EXE

if [ $ARCH != "windows_x86" ] && [ $ARCH != "windows_amd64" ]; then
    cp release/bin/libftdi1-config $PACKAGE_DIR/$NAME/bin/libftdi1-config
fi
