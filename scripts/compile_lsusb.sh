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
echo "--> Downloading: $REL_LIBUSB"
echo ""
test -e $TAR_LIBUSB || wget $REL_LIBUSB

# -- Unpack the release
echo "--> Extracting: $TAR_LIBUSB"
echo ""
tar jxf $TAR_LIBUSB

# -- Copy the upstream sources into the build directory
echo "--> Build dir: $BUILD_DIR"
echo ""
rsync -a "$LIBUSB" "$BUILD_DIR" --exclude .git

# -- Change dir to the libusb source folder
LIBUSB_DIR="$BUILD_DIR"/"$LIBUSB"
echo "--> Current build dir: $LIBUSB_DIR"
cd "$LIBUSB_DIR" || exit

PREFIX=$BUILD_DIR/$LIBUSB/release

#-- Build libusb
echo "--> Building the libusb package"
./configure --prefix="$PREFIX" --host="$HOST" --enable-udev=no "$CONFIG_FLAGS"
make -j"$J"
make install


#-- Build lsusb
echo "--> Building lsusb"
cd examples || exit
if [ "$ARCH" == "darwin" ]; then
  $CC -o lsusb listdevs.c -lusb-1.0 -I../libusb
elif [ "$ARCH" == "darwin_arm64" ]; then
  $CC -o lsusb listdevs.c -lusb-1.0 -I../libusb -L/opt/homebrew/opt/libusb/lib/
else
  $CC -o lsusb listdevs.c -static -lusb-1.0 -lpthread -L"$PREFIX"/lib -I"$PREFIX"/include/libusb-1.0
fi
cd ..

echo "--> EXE: $EXE"

# -- Test the generated executables
test_bin examples/lsusb"$EXE"

# -- Copy the executable into the packages/bin dir
DESTINATION="$PACKAGE_DIR"/"$NAME"/bin/lsusb"$EXE"
echo "--> Generated file: $DESTINATION"
cp examples/lsusb"$EXE" "$DESTINATION"
