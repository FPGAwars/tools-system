# -- Compile lsftdi script

LSFTDI=libftdi1-1.2
REL_LSFTDI=https://www.intra2net.com/en/developer/libftdi/download/$LSFTDI.tar.bz2

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
test -e $LSFTDI.tar.bz2 || wget $REL_LSFTDI

# -- Unpack the release
tar vjxf $LSFTDI.tar.bz2

# -- Copy the upstream sources into the build directory
rsync -a $LSFTDI $BUILD_DIR --exclude .git

cd $BUILD_DIR/$LSFTDI

#-- Build static lsftdi

cd examples

if [ $ARCH == "linux_x86_64" ]; then
  gcc -o lsftdi find_all.c -lftdi1 -lusb-1.0 -lpthread -I ../src -static -L $WORK_DIR/build-data/$ARCH/lib
fi

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
  i686-w64-mingw32-gcc -o lsftdi.exe find_all.c -lftdi1 -lusb-1.0 -lpthread -I ../src -static -L $WORK_DIR/build-data/$ARCH/lib
fi

if [ $ARCH == "darwin" ]; then
  clang -o lsftdi find_all.c -lftdi1 -lusb-1.0
fi

cd ..

# -- Test the generated executables
if [ $ARCH != "darwin" ]; then
  test_bin examples/lsftdi$EXT
fi

# -- Copy the executable into the packages/bin dir
cp examples/lsftdi$EXT $PACKAGE_DIR/$NAME/bin
