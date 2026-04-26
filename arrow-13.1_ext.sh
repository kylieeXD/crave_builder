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
git clone https://github.com/Cilok-LAB/android_device_xiaomi_surya.git device/xiaomi/surya
git clone https://github.com/HinohArata/surya_vendor.git --depth=1 vendor/xiaomi/surya
git clone https://gitea.com/HinohArata/firmware_xiaomi_surya.git --depth=1 firmware/xiaomi/surya
git clone https://gitlab.com/HinohArata/device_xiaomi_surya-miuicamera device/xiaomi/surya-miuicamera
git clone https://gitlab.com/kylieeXD/vendor_xiaomi_surya-miuicamera --depth=1 vendor/xiaomi/surya-miuicamera
git clone https://github.com/Cilok-LAB/android_kernel_xiaomi_surya --depth=1 kernel/xiaomi/surya
git clone https://github.com/Mnzz-Prjkt/android_private_keys vendor/private/keys/keys.mk
git clone https://github.com/LineageOS/android_hardware_xiaomi.git -b lineage-20 hardware/xiaomi

# Symlink libncurses 6 >> 5 for Q based
sudo ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
sudo ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so.6   /usr/lib/x86_64-linux-gnu/libtinfo.so.5

# Export
export BUILD_USERNAME=khayloaf
export BUILD_HOSTNAME=crave

# Set up build environment
. build/envsetup.sh

# Build rom
lunch arrow_surya-userdebug
m bacon

# Upload ROM
curl -T "out/target/product/surya/Arrow*surya*.zip" -u :dc4f2d6d-ef86-4241-af44-44f311a0ecb9 https://pixeldrain.com/api/file/
