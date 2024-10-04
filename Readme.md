# arm-none-eabi-gcc-deb
Automated x86_64 deb package builder for GNU Arm Embedded Toolchain (bare-metal)<br>
This currently creates a deb installer for version **13.3.rel1**<br>
This installs these elements of the toolchain:
 * arm-none-eabi-addr2line
 * arm-none-eabi-ar
 * arm-none-eabi-as
 * arm-none-eabi-c++
 * arm-none-eabi-c++filt
 * arm-none-eabi-cpp
 * arm-none-eabi-elfedit
 * arm-none-eabi-g++
 * arm-none-eabi-gcc
 * arm-none-eabi-gcc-13.3.1
 * arm-none-eabi-gcc-ar
 * arm-none-eabi-gcc-nm
 * arm-none-eabi-gcc-ranlib
 * arm-none-eabi-gcov
 * arm-none-eabi-gcov-dump
 * arm-none-eabi-gcov-tool
 * arm-none-eabi-gdb
 * arm-none-eabi-gdb-add-index
 * arm-none-eabi-gdb-add-index-py
 * arm-none-eabi-gdb-py
 * arm-none-eabi-gfortran
 * arm-none-eabi-gprof
 * arm-none-eabi-ld
 * arm-none-eabi-ld.bfd
 * arm-none-eabi-lto-dump
 * arm-none-eabi-nm
 * arm-none-eabi-objcopy
 * arm-none-eabi-objdump
 * arm-none-eabi-ranlib
 * arm-none-eabi-readelf
 * arm-none-eabi-size
 * arm-none-eabi-strings
 * arm-none-eabi-strip


Based directly on the script from https://askubuntu.com/a/1371525/1379646

Creates deb to install / uninstall gcc from https://developer.arm.com/-/media/Files/downloads/gnu/{VER}/binrel/arm-gnu-toolchain-{VER}-{ARCH_IN}-arm-none-eabi.tar.xz

Please note that there is an issue with running **arm-none-eabi-gdb** on Ubuntu 24.04 'noble' - it is missing access to:
 * libncursesw.so.5
 * libtinfo.so.5

To work around this, this kludge **_seems_** to work:

```
curl http://security.debian.org/debian-security/pool/updates/main/n/ncurses/libncurses5_6.1+20181013-2+deb10u5_amd64.deb -o libncurses.deb
curl http://security.debian.org/debian-security/pool/updates/main/n/ncurses/libtinfo5_6.1+20181013-2+deb10u5_amd64.deb   -o libtinfo.deb
sudo dpkg -i libncurses.deb libtinfo.deb
sudo ln -s /lib/x86_64-linux-gnu/libncursesw.so.6 /lib/x86_64-linux-gnu/libncursesw.so.5
```