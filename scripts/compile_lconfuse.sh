#!/bin/bash
# -- Compile libconfuse script

VER=3.2.2
LIBCONFUSE=confuse-$VER
TAR_LIBCONFUSE=$LIBCONFUSE.tar.gz
REL_LIBCONFUSE=https://github.com/martinh/libconfuse/releases/download/v$VER/$TAR_LIBCONFUSE

# -- Setup
# shellcheck source=build_setup.sh
. "$WORK_DIR"/scripts/build_setup.sh

cd "$UPSTREAM_DIR" || exit

# -- Check and download the release
test -e $TAR_LIBCONFUSE || wget $REL_LIBCONFUSE

# -- Unpack the release
tar zxf $TAR_LIBCONFUSE

# -- Copy the upstream sources into the build directory
rsync -a $LIBCONFUSE "$BUILD_DIR" --exclude .git

cd "$BUILD_DIR/$LIBCONFUSE" || exit

PREFIX=$BUILD_DIR/$LIBCONFUSE/release

#-- Build libconfuse

./configure --prefix="$PREFIX" --host="$HOST" "$CONFIG_FLAGS"
make
make install

#-- Build simple
cd examples || exit
if [ "$ARCH" == "darwin" ]; then
  $CC -o simple simple.c -lconfuse -I../src
elif [ "$ARCH" == "darwin_arm64" ]; then
  make simple
else
  $CC -o simple simple.c -static -lconfuse -L"$PREFIX"/lib -I"$PREFIX"/include
fi
cd ..

# -- Test the generated executables
test_bin examples/simple"$EXE"
