#!/bin/bash

# WARNING: This will remove all local changes!
rm -rf .repo/local_manifests
rm -rf kernel/xiaomi
rm -rf device/xiaomi
rm -rf hardware/xiaomi
rm -rf vendor/xiaomi
rm -rf vendor/private

# Initialize repo
repo init --depth=1 --no-repo-verify -u https://github.com/Ghnkz/android_manifest.git -b arrow-13.1_ext --git-lfs -g default,-mips,-darwin,-notdefault

# Sync the repositories
/opt/crave/resync.sh
repo sync

# Clone device tree
git clone https://github.com/HinohArata/device_xiaomi_surya-arrow.git device/xiaomi/surya
git clone https://github.com/HinohArata/android_vendor_xiaomi_surya.git vendor/xiaomi/surya
git clone https://gitea.com/HinohArata/firmware_xiaomi_surya.git firmware/xiaomi/surya
git clone https://gitlab.com/HinohArata/device_xiaomi_surya-miuicamera device/xiaomi/surya-miuicamera
git clone https://gitlab.com/HinohArata/vendor_xiaomi_surya-miuicamera vendor/xiaomi/surya-miuicamera
git clone https://github.com/Cilok-LAB/android_kernel_xiaomi_surya kernel/xiaomi/surya
git clone https://github.com/Mnzz-Prjkt/android_private_keys vendor/private/keys/keys.mk
git clone https://github.com/HinohArata/hardware_xiaomi.git hardware/xiaomi

# Change new path of sign keys
sed -i 's|vendor/private-keys/keys/keys.mk|vendor/private/keys/keys.mk|' device/xiaomi/surya/device.mk

# Symlink libncurses 6 >> 5 for Q based
sudo ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
sudo ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so.6   /usr/lib/x86_64-linux-gnu/libtinfo.so.5

# Export
export BUILD_USERNAME=khayloaf
export BUILD_HOSTNAME=crave

# Set up build environment
. build/envsetup.sh

# Build rom
lunch arrow_aurora-userdebug
m bacon
