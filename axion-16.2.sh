#!/bin/bash
for d in .repo/local_manifests kernel/xiaomi device/xiaomi device/mediatek/sepolicy_vndr packages/apps/DolbyAtmos hardware/xiaomi vendor/xiaomi vendor/private; do rm -rf "$d"; done
for s in "$HOME/.s" "$(pwd)/.s"; do [ -f "$s" ] && source "$s" || echo ".s not found in $(dirname $s)"; done
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.2 --git-lfs;/opt/crave/resync.sh;repo sync --force-sync --no-clone-bundle --no-tags
git clone https://github.com/lineageos-personal/android_packages_apps_DolbyAtmos packages/apps/DolbyAtmos;git clone https://kylieeXD:{$STGHFR}@github.com/Cilok-LAB/android_device_xiaomi_klee -b lineage-23.2 device/xiaomi/klee
cd device/xiaomi/klee && curl -L https://pixeldrain.com/api/file/wnW9EQQY -o axion.patch && patch -p1 < axion.patch && git clean -fd && cd -
for lib in libncurses libtinfo; do sudo ln -sf /usr/lib/x86_64-linux-gnu/${lib}.so.6 /usr/lib/x86_64-linux-gnu/${lib}.so.5 done
export BUILD_USERNAME=khayloaf BUILD_HOSTNAME=crave
. build/envsetup.sh && gk -s
axion klee userdebug core;ax -br -j$(nproc --all) | tee build.log
ZIP=$(grep "Package Complete:" build.log | sed 's/Package Complete: //' | tr -d '[:space:]')
curl -s -F "file=@${ZIP}" "https://store1.gofile.io/contents/uploadfile"
