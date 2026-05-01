#!/bin/bash

# WARNING: This will remove all local changes!
rm -rf .repo/local_manifests
rm -rf kernel/xiaomi
rm -rf device/xiaomi
rm -rf hardware/xiaomi
rm -rf hardware/dolby
rm -rf vendor/xiaomi
rm -rf vendor/private

# Initialize repo
repo init --depth=1 --no-repo-verify -u https://github.com/Ghnkz/android_manifest.git -b arrow-13.1_ext --git-lfs -g default,-mips,-darwin,-notdefault

# Sync the repositories
/opt/crave/resync.sh
repo sync

# Clone device tree
git clone https://github.com/Cilok-LAB/android_device_xiaomi_surya.git -b arrow-13.1_ext device/xiaomi/surya

# Symlink libncurses 6 >> 5 for Q based
sudo ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
sudo ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so.6   /usr/lib/x86_64-linux-gnu/libtinfo.so.5

# Export
export BUILD_USERNAME=khayloaf
export BUILD_HOSTNAME=crave
unset OUT_DIR
export OUT_DIR=out

# Set up build environment
. build/envsetup.sh

# Build rom
lunch arrow_surya-userdebug
m bacon
