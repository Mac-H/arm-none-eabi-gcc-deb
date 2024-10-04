#!/bin/bash -eu
# https://askubuntu.com/a/1371525
# https://developer.arm.com/downloads/-/gnu-rm

this_dir="$(realpath -m "$(dirname "$0")")"

PACKAGE_NAME=gcc-arm-none-eabi
ARCH_IN="x86_64"
MAINTAINER="Mac@SpaceMachines.com"
DESCRIPTION="GNU Arm Embedded Toolchain: bare-metal targetting ARM Cortex-M and Cortex-R processors"

#
#
#
VER=${VER:-13.3.rel1}


ARCH_OUT="$ARCH_IN" ; [[ "$ARCH_OUT" == "x86_64" ]] && ARCH_OUT="amd64"

URL=https://developer.arm.com/-/media/Files/downloads/gnu/${VER}/binrel/arm-gnu-toolchain-${VER}-${ARCH_IN}-arm-none-eabi.tar.xz
echo "Creating ${PACKAGE_NAME}  debian ($ARCH_OUT) package -- version $VER"
echo "Downloading..."

tar_fname="$(pwd)/${PACKAGE_NAME}.tar.xz"

[[ -f "$tar_fname" ]] || wget -q --show-progress -O "$tar_fname" "$URL"

tmp_dir="$(mktemp -d "${PACKAGE_NAME}_tmp_XXXX")"
echo "Extracting to '$tmp_dir'..."

if pushd "$tmp_dir" >/dev/null ; then
    tar -xf "$tar_fname"
    popd >/dev/null || echo "Error: popd failed"
fi

#
# Build package contents
#
echo Build Package Contents
{
    rm -rf "$PACKAGE_NAME"
    mkdir -p "$PACKAGE_NAME"

    cp "$this_dir/src/"* "$PACKAGE_NAME" -r

    mkdir -p "$PACKAGE_NAME"
    mkdir -p "$PACKAGE_NAME/DEBIAN"
    mkdir -p "$PACKAGE_NAME/usr"

    {
        echo "Package: $PACKAGE_NAME"
        echo "Version: $VER"
        echo "Architecture: ${ARCH_OUT}"
        echo "Maintainer: $MAINTAINER"
        echo "Description: $DESCRIPTION"
    } > "$PACKAGE_NAME/DEBIAN/control"

    mv "$tmp_dir/arm-"*/* "$PACKAGE_NAME/usr/"
    rm -rf $PACKAGE_NAME/usr/*.txt

    echo "+----------------------------------------------"
    {
        cat "$PACKAGE_NAME/DEBIAN/control"
        echo
        tree "${PACKAGE_NAME}" -L 3 --noreport
    } | sed 's/^/|  /'
    echo "+----------------------------------------------"
}

rm -rf "$tmp_dir"

#
# Create debian file
#
DEB_FILE_NAME="${PACKAGE_NAME}-${VER}-${ARCH_IN}.deb"

dpkg-deb --root-owner-group --build "$PACKAGE_NAME"  "$DEB_FILE_NAME"
echo
echo "File generated: ${DEB_FILE_NAME}"
echo "Install with \` sudo dpkg -i ${DEB_FILE_NAME@Q} \`"
echo
echo "Hash (MD5)                      | Filename                              "
echo "--------------------------------|---------------------------------------"
md5sum "$DEB_FILE_NAME"
echo

