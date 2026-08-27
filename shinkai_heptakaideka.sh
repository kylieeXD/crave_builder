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
repo init --depth=1 -u https://github.com/Shinkaiprjkt/shinkai_manifest.git -b heptakaideka --git-lfs

# Clone device tree manifest
git clone https://github.com/xiaomi-klee-devs/android_manifest .repo/local_manifests -b android/lineage-24.0

# Sync the repositories
/opt/crave/resync.sh
repo sync --force-sync --no-clone-bundle --no-tags

# Symlink libncurses 6 >> 5 for Q based
sudo ln -s /usr/lib/x86_64-linux-gnu/libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5
sudo ln -s /usr/lib/x86_64-linux-gnu/libtinfo.so.6   /usr/lib/x86_64-linux-gnu/libtinfo.so.5

# Export
export BUILD_USERNAME=khayloaf
export BUILD_HOSTNAME=crave

# Set up build environment
. b*/env*

# Build rom
breakfast klee
m shinkai | tee build.log

# Extract file name from the log
ZIP=$(grep "Package Complete:" build.log | sed 's/Package Complete: //' | tr -d '[:space:]')

# Upload rom
curl -s -F "file=@${ZIP}" "https://store1.gofile.io/contents/uploadfile"
