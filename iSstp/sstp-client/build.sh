#!/bin/bash

set -euo pipefail

PATH=/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null

VERSION=1.0.15
URL=https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-${VERSION}.tar.gz

function brew_cellar_path() {
    echo $($BREW_PATH --cellar "$1")/$($BREW_PATH info --json "$1" | jq -r '.[0].installed[0].version')
}

env

for arch in arm64 x86_64; do
    mkdir -p $arch
    pushd $arch/

    if ! [ -d ./homebrew ]; then
        mkdir homebrew
        curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
    fi

    BREW_PATH=$(realpath homebrew/bin/brew)
    HOMEBREW_PREFIX=$($BREW_PATH --prefix)
    export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/openssl@1.1/lib/pkgconfig:$HOMEBREW_PREFIX/opt/libevent/lib/pkgconfig"

    arch -$arch $BREW_PATH install pkg-config libevent openssl@1.1 automake libtool

    if ! [ -d ./build ]; then
        mkdir -p build
        pushd build

        wget $URL
        tar zxf sstp-client-${VERSION}.tar.gz --strip-components=1 -C .

        find . -name 'Makefile.in' -exec rm {} \;

        patch -p0 < ../../configure.ac.patch
        patch -p0 < ../../src_Makefile.am.patch
        patch -p0 < ../../src_libsstp-api_Makefile.am.patch

        arch -$arch autoreconf -f -i
        arch -$arch ./configure \
            --disable-dependency-tracking \
            --disable-silent-rules \
            --disable-ppp-plugin \
            --with-runtime-dir=/var/run/sstpc \
            --with-openssl=$(brew_cellar_path openssl@1.1) \
            --with-libevent=$(brew_cellar_path libevent) \
            LIBEVENT_STATIC_LIBS="$HOMEBREW_PREFIX/opt/libevent/lib/libevent.a" \
            OPENSSL_STATIC_LIBS="$HOMEBREW_PREFIX/opt/openssl@1.1/lib/libssl.a $HOMEBREW_PREFIX/opt/openssl@1.1/lib/libcrypto.a" \
        popd
    fi
    
    pushd build
    arch -$arch make -j $(nproc)

    # ./arch/build
    popd

    # ./arch
    popd
done

mkdir -p out
lipo -create -output out/sstpc x86_64/build/src/sstpc arm64/build/src/sstpc
