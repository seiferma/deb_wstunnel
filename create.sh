#!/bin/bash

# parameters
export version=$1
export arch=$2

# constants
if [[ -z "$BUILD_DIR" ]]; then
    BUILD_DIR=/tmp/build
fi
FIXED_MTIME="2025-04-20 06:00:00"
FIXED_MTIME_TOUCH="202504200600.00"

# preparations
set -e
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
wget -O $BUILD_DIR/tunnel.tar.gz https://github.com/erebe/wstunnel/releases/download/v"$version"/wstunnel_"$version"_linux_"$arch".tar.gz
tar -xvzf $BUILD_DIR/tunnel.tar.gz -C $BUILD_DIR
chmod +x $BUILD_DIR/wstunnel

# data.tar.gz
mkdir -p $BUILD_DIR/data/usr/bin
mv $BUILD_DIR/wstunnel $BUILD_DIR/data/usr/bin
tar cvf $BUILD_DIR/data.tar --mtime="$FIXED_MTIME" --owner=root --group=root -C $BUILD_DIR/data .
touch -a -m -t "$FIXED_MTIME_TOUCH" $BUILD_DIR/data.tar
sudo chown root:root $BUILD_DIR/data.tar
gzip -c $BUILD_DIR/data.tar > $BUILD_DIR/data.tar.gz
touch -a -m -t "$FIXED_MTIME_TOUCH" $BUILD_DIR/data.tar.gz

# control.tar.gz
mkdir -p $BUILD_DIR/control
envsubst < control > $BUILD_DIR/control/control
tar cvf $BUILD_DIR/control.tar --mtime="$FIXED_MTIME"  --owner=root --group=root -C $BUILD_DIR/control .
touch -a -m -t "$FIXED_MTIME_TOUCH" $BUILD_DIR/control.tar
sudo chown root:root $BUILD_DIR/control.tar
gzip -c $BUILD_DIR/control.tar > $BUILD_DIR/control.tar.gz
touch -a -m -t "$FIXED_MTIME_TOUCH" $BUILD_DIR/control.tar.gz

# debian-binary
echo 2.0 > $BUILD_DIR/debian-binary
touch -a -m -t "$FIXED_MTIME_TOUCH" $BUILD_DIR/debian-binary

# deb packaging
sudo chown root:root -R $BUILD_DIR
ar -r $BUILD_DIR/wstunnel_"$version"_"$arch".deb $BUILD_DIR/debian-binary $BUILD_DIR/control.tar.gz $BUILD_DIR/data.tar.gz
