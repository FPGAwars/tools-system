#!/bin/bash
##################################
#      System tools cleaner      #
##################################

# -- Target architectures
ARCH=$1
TARGET_ARCHS="linux_x86_64 linux_i686 linux_armv7l linux_aarch64 windows_x86 windows_amd64 darwin darwin_arm64"

# -- Store current dir
WORK_DIR=$PWD
# -- Folder for building the source code
BUILDS_DIR=$WORK_DIR/_builds
# -- Folder for storing the generated packages
PACKAGES_DIR=$WORK_DIR/_packages

# -- Check ARCH
if [[ $# -gt 1 ]]; then
  echo ""
  echo "Error: too many arguments"
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo ""
  echo "Usage: bash clean.sh TARGET"
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

printf "Are you sure? [y/N]:%s" "${NC} "
read -r RESP
case "$RESP" in
    [yY][eE][sS]|[yY])
      # -- Directory for compiling the tools
      BUILD_DIR=$BUILDS_DIR/build_$ARCH

      # -- Directory for installation the target files
      PACKAGE_DIR=$PACKAGES_DIR/build_$ARCH

      # -- Remove the package dir
      rm -r -f "$PACKAGE_DIR"

      # -- Remove the build dir
      rm -r -f "$BUILD_DIR"

      echo ""
      echo ">> CLEAN"
      ;;
    *)
      echo ""
      echo ">> ABORT"
      ;;
esac
