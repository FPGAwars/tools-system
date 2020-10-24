#!/bin/bash
# -- Compile lsftdi script

VER=1.4
LIBFTDI1=libftdi1-$VER
TAR_LIBFTDI1=$LIBFTDI1.tar.bz2
REL_LIBFTDI1=https://www.intra2net.com/en/developer/libftdi/download/$TAR_LIBFTDI1

VER=1.0.22
LIBUSB=libusb-$VER

VER=3.2.2
LIBCONFUSE=confuse-$VER

# -- Setup
# shellcheck source=build_setup.sh
. "$WORK_DIR"/scripts/build_setup.sh

cd "$UPSTREAM_DIR" || exit

# -- Check and download the release
test -e $TAR_LIBFTDI1 || wget $REL_LIBFTDI1

# -- Unpack the release
tar jxf $TAR_LIBFTDI1

# -- Copy the upstream sources into the build directory
rsync -a "$LIBFTDI1" "$BUILD_DIR" --exclude .git

echo "----> Copiando $LIBFTDI1 $BUILD_DIR"

cd "$BUILD_DIR"/"$LIBFTDI1" || exit

PREFIX=$BUILD_DIR/$LIBFTDI1/release
LIBUSB_PREFIX=$BUILD_DIR/$LIBUSB/release
LIBCONFUSE_PREFIX=$BUILD_DIR/$LIBCONFUSE/release

#-- Build libftdi
if [ "$ARCH" != "darwin" ]; then
  mkdir -p build
  cd build || exit
  export PKG_CONFIG_PATH=$LIBUSB_PREFIX/lib/pkgconfig
  cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX $CMAKE_FLAGS
  make -j$J
  make install
  cd ..
fi

#-- Build lsftdi
cd examples || exit
if [ "$ARCH" == "darwin" ]; then
  $CC -o lsftdi find_all.c -lftdi1 -lusb-1.0 -I../src
else
  $CC -o lsftdi find_all.c -static -lftdi1 -lusb-1.0 -lpthread -L"$PREFIX"/lib -L"$LIBUSB_PREFIX"/lib -I"$PREFIX"/include/libftdi1
fi
cd ..

#-- Build ftdi_eeprom
cd ftdi_eeprom || exit
if [ "$ARCH" == "darwin" ]; then
  $CC -o ftdi_eeprom main.c -lftdi1 -lusb-1.0 -lconfuse -I../src -I"$WORK_DIR"/build-data/includes -I"$PREFIX"/include/libftdi1 -I"$BUILD_DIR"/"$LIBUSB"/libusb -I"$BUILD_DIR"/"$LIBCONFUSE"/src
else
  $CC -o ftdi_eeprom main.c -static -lftdi1 -lusb-1.0 -lconfuse -lpthread -L"$PREFIX"/lib -L"$LIBUSB_PREFIX"/lib -L"$LIBCONFUSE_PREFIX"/lib -I"$WORK_DIR"/build-data/includes -I"$PREFIX"/include/libftdi1 -I"$LIBUSB_PREFIX"/include/libusb-1.0 -I"$LIBCONFUSE_PREFIX"/include
fi
cd ..

# -- Test the generated executables
test_bin examples/lsftdi$EXE
test_bin ftdi_eeprom/ftdi_eeprom$EXE

# -- Copy the executable into the packages/bin dir
cp examples/lsftdi$EXE "$PACKAGE_DIR"/"$NAME"/bin/lsftdi$EXE
cp ftdi_eeprom/ftdi_eeprom$EXE "$PACKAGE_DIR"/"$NAME"/bin/ftdi_eeprom$EXE
