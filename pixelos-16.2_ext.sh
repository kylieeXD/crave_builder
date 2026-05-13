#!/bin/bash

# WARNING: This will remove all output!
rm -rf out

# WARNING: This will remove all local changes!
rm -rf .repo/local_manifests
rm -rf kernel/xiaomi
rm -rf device/xiaomi
rm -rf device/mediatek/sepolicy_vndr
rm -rf hardware/dolby
rm -rf hardware/xiaomi
rm -rf vendor/xiaomi
rm -rf vendor/private

# Initialize repo
repo init --depth=1 -u https://github.com/Mnzz-Prjkt/android_manifest.git -b sixteen-qpr2 --git-lfs

# Sync the repositories
/opt/crave/resync.sh
repo sync --force-sync --no-clone-bundle --no-tags

# Clone device tree
git clone https://github.com/Cilok-LAB/android_device_xiaomi_klee -b lineage-23.2 device/xiaomi/klee

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
lunch custom_klee-bp4a-userdebug
m pixelos | tee build_$(date +%Y%m%d_%H%M%S).log
