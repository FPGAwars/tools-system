#!/bin/bash
# -- Compile lsusb script

VER=1.0.22
LIBUSB=libusb-$VER
TAR_LIBUSB=$LIBUSB.tar.bz2
REL_LIBUSB=https://github.com/libusb/libusb/releases/download/v$VER/$TAR_LIBUSB

# -- Setup
# shellcheck source=build_setup.sh
. "$WORK_DIR"/scripts/build_setup.sh

cd "$UPSTREAM_DIR" || exit

# -- Check and download the release
test -e $TAR_LIBUSB || wget $REL_LIBUSB

# -- Unpack the release
tar jxf $TAR_LIBUSB

# -- Copy the upstream sources into the build directory
rsync -a "$LIBUSB" "$BUILD_DIR" --exclude .git

cd "$BUILD_DIR"/"$LIBUSB" || exit

PREFIX=$BUILD_DIR/$LIBUSB/release

#-- Build libusb
if [ "$ARCH" != "darwin" ]; then
  ./configure --prefix="$PREFIX" --host=$HOST --enable-udev=no "$CONFIG_FLAGS"
  make -j$J
  make install
fi

#-- Build lsusb
cd examples || exit
if [ "$ARCH" == "darwin" ]; then
  $CC -o lsusb listdevs.c -lusb-1.0 -I../libusb
else
  $CC -o lsusb listdevs.c -static -lusb-1.0 -lpthread -L"$PREFIX"/lib -I"$PREFIX"/include/libusb-1.0
fi
cd ..

echo "-----> EXE: $EXE"

# -- Test the generated executables
test_bin examples/lsusb$EXE

# -- Copy the executable into the packages/bin dir
cp examples/lsusb$EXE "$PACKAGE_DIR"/"$NAME"/bin/lsusb$EXE
