#!/bin/bash
##################################
#      System tools builder      #
##################################

# Set english language for propper pattern matching
export LC_ALL=C

# Generate tools-system-arch-ver.tar.gz from source code
# sources: https://github.com/FPGAwars/tools-system

VERSION=1.1.0

# -- Target architectures
ARCH=$1
TARGET_ARCHS="linux_x86_64 linux_i686 linux_armv7l linux_aarch64 windows_x86 windows_amd64 darwin"

# -- Tools name
NAME=tools-system

# -- Debug flags
INSTALL_DEPS=1
COMPILE_LSUSB=1
COMPILE_LCONFUSE=1
COMPILE_LSFTDI=1
CREATE_PACKAGE=1

# -- Store current dir
WORK_DIR=$PWD
# -- Folder for building the source code
BUILDS_DIR=$WORK_DIR/_builds
# -- Folder for storing the generated packages
PACKAGES_DIR=$WORK_DIR/_packages
# --  Folder for storing the source code from github
UPSTREAM_DIR=$WORK_DIR/_upstream

# -- Create the build directory
mkdir -p $BUILDS_DIR
# -- Create the packages directory
mkdir -p $PACKAGES_DIR
# -- Create the upstream directory and enter into it
mkdir -p $UPSTREAM_DIR

# -- Test script function
function test_bin {
  $WORK_DIR/test/test_bin.sh $1
  if [ $? != "0" ]; then
    exit 1
  fi
}

# -- Print function
function print {
  echo ""
  echo $1
  echo ""
}

# -- Check ARCH
if [[ $# > 1 ]]; then
  echo ""
  echo "Error: too many arguments"
  exit 1
fi

if [[ $# < 1 ]]; then
  echo ""
  echo "Usage: bash build.sh TARGET"
  echo ""
  echo "Targets: $TARGET_ARCHS"
  exit 1
fi

if [[ $ARCH =~ [[:space:]] || ! $TARGET_ARCHS =~ (^|[[:space:]])$ARCH([[:space:]]|$) ]]; then
  echo ""
  echo ">>> WRONG ARCHITECTURE \"$ARCH\""
  exit 1
fi

echo ""
echo ">>> ARCHITECTURE \"$ARCH\""

# -- Directory for compiling the tools
BUILD_DIR=$BUILDS_DIR/build_$ARCH

# -- Directory for installating the target files
PACKAGE_DIR=$PACKAGES_DIR/build_$ARCH

# --------- Instal dependencies ------------------------------------
if [ $INSTALL_DEPS == "1" ]; then

  print ">> Install dependencies"
  . $WORK_DIR/scripts/install_dependencies.sh

fi

# -- Create the build dir
mkdir -p $BUILD_DIR

# -- Create the package folders
mkdir -p $PACKAGE_DIR/$NAME/bin

# --------- Compile lsusb ------------------------------------------
if [ $COMPILE_LSUSB == "1" ]; then

  print ">> Compile lsusb"
  . $WORK_DIR/scripts/compile_lsusb.sh

fi

# --------- Compile lconfuse ------------------------------------------
if [ $COMPILE_LCONFUSE == "1" ]; then

  print ">> Compile lconfuse"
  . $WORK_DIR/scripts/compile_lconfuse.sh

fi

# --------- Compile lsftdi -----------------------------------------
if [ $COMPILE_LSFTDI == "1" ]; then

  print ">> Compile lsftdi"
  . $WORK_DIR/scripts/compile_lsftdi.sh

fi

# --------- Create the package -------------------------------------
if [ $CREATE_PACKAGE == "1" ]; then

  print ">> Create package"
  . $WORK_DIR/scripts/create_package.sh

fi
