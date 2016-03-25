##############################################
# libusb builder for Linux 64 bits           #
##############################################

LIBUSB_GIT_REPO=https://github.com/libusb/libusb/releases/download/v1.0.20
LIBUSB_FILENAME=libusb-1.0.20
LIBUSB_FILENAME_TAR=$LIBUSB_FILENAME.tar.bz2
UPSTREAM=upstream
PACK_DIR=packages
NAME=libusb
ARCH=linux_x86_64
BUILD_DIR=build_$ARCH
PREFIX=$HOME/.$ARCH
VERSION=1

# Store current dir
WORK=$PWD

# -- TARGET: CLEAN. Remove the build dir and the generated packages
# --  then exit
if [ "$1" == "clean" ]; then
  echo "-----> CLEAN"

  exit
fi

# Install dependencies
echo "Instalando DEPENDENCIAS:"
sudo apt-get install libtool autoconf libudev-dev libudev1

# Create the upstream folder
mkdir -p $UPSTREAM

# Create the packages directory
mkdir -p $PACK_DIR

# Create the build dir
mkdir -p $BUILD_DIR ;

#-- Download the src tarball, if it has not been done yet
cd $UPSTREAM
test -e $LIBUSB_FILENAME_TAR ||
    (echo ' ' && \
    echo '--> DOWNLOADING LIBUSB source package' && \
    wget $LIBUSB_GIT_REPO/$LIBUSB_FILENAME_TAR)

#-- Extract the src files, if it has not been done yet
test -e $LIBUSB_FILENAME ||
    (echo ' ' && \
    echo '--> UNCOMPRESSING LIBUSB package' && \
    tar vjxf $LIBUSB_FILENAME_TAR)

#-- Copy the upstream libusb into the build dir
cd $WORK
test -d $BUILD_DIR/$LIBUSB_FILENAME ||
     (echo ' ' && \
     echo '--> COPYING LIBUSB upstream into build_dir' && \
     cp -r $UPSTREAM/$LIBUSB_FILENAME $BUILD_DIR)


# ---------------------------- Building the library
cd $BUILD_DIR/$LIBUSB_FILENAME

# Prepare for building
./configure

# Compile!
make

# -- Copy the dev files into $BUILD_DIR/include $BUILD_DIR/lbs

#-- Compile the listdevs-example









#BUILD=x86-unknown-linux-gnu
#HOST=i686-linux-gnu
#TARGET=i686make-linux-gnu



#PACKNAME=$NAME-$ARCH-$VERSION



#TARBALL=$PWD/$BUILD_DIR/$PACKNAME.tar.gz
#ZIPBALL=$PWD/$BUILD_DIR/$PACKNAME.zip
#ZIPEXAMPLE=listdevs-example-$ARCH-$VERSION.zip


# Install libusb
#make install

# Cross-compile one example
#cd examples
#gcc -m32 -o listdevs listdevs.c -I $HOME/.linux_i686/include/libusb-1.0  -L /lib/i386-linux-gnu/  $HOME/.linux_i686/lib/libusb-1.0.a -lpthread -ludev

# Zip the .exe file and move it to the main directory
#zip $ZIPEXAMPLE listdevs.exe
#mv $ZIPEXAMPLE $WORK/$PACK_DIR

# Create the tarball
#cd $PREFIX
#tar vzcf $TARBALL *
#mv $TARBALL $WORK/$PACK_DIR

# Create the zipball
#zip -r $ZIPBALL *
#mv $ZIPBALL $WORK/$PACK_DIR
