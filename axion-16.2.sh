#!/bin/bash

# WARNING: This will remove all output!
# rm -rf out

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
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.2 --git-lfs

# Sync the repositories
/opt/crave/resync.sh
repo sync --force-sync --no-clone-bundle --no-tags

# Fixup Dolby
git clone https://github.com/PixelOS-AOSP/android_packages_apps_DolbyAtmos packages/apps/XiaomiDolby
sed -i 's/DolbyAtmos/XiaomiDolby/g' packages/apps/XiaomiDolby/Android.bp

# Clone device tree
git clone https://github.com/Cilok-LAB/android_device_xiaomi_klee -b lineage-23.2 device/xiaomi/klee

# Fixup sign
cd device/xiaomi/klee && curl -L https://pixeldrain.com/api/file/SoktJVu1 -o axion.patch
patch -p1 < axion.patch && git clean -fd && cd -

# Symlink libncurses 6 >> 5 for Q based
sudo ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
sudo ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so.6   /usr/lib/x86_64-linux-gnu/libtinfo.so.5

# Export
export BUILD_USERNAME=khayloaf
export BUILD_HOSTNAME=crave

# Set up build environment
. build/envsetup.sh
gk -s

# Build rom
axion klee userdebug core
ax -br -j$(nproc --all) | tee build.log

# Extract file name from the log
ZIP=$(grep "Package Complete:" build.log | sed 's/Package Complete: //' | tr -d '[:space:]')

# Upload rom
curl -s -F "file=@${ZIP}" "https://store1.gofile.io/contents/uploadfile"
