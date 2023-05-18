#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="21.02.7"
BUILDER="https://downloads.openwrt.org/releases/${BUILD_VERSION}/targets/x86/64/openwrt-imagebuilder-${BUILD_VERSION}-x86-64.Linux-x86_64.tar.xz"
KERNEL_PARTSIZE=128 #Kernel-Partitionsize in MB
ROOTFS_PARTSIZE=1642 #Rootfs-Partitionsize in MB
BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/
echo "Moving IPKs to packages directory..."
mv ${BASEDIR}/packages/* $(pwd)/packages/
ls -la $(pwd)/packages/
echo "Done!"

# clean previous images
make clean

# Packages are added if no prefix is given, '-packagename' does not integrate a package
sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=$KERNEL_PARTSIZE/g" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE/g" .config

make image PROFILE="generic" \
PACKAGES="base-files beep busybox ca-bundle cgi-io curl dnsmasq \
dropbear e2fsprogs firewall fstools fwtool getrandom grub2 \
grub2-efi htop ip6tables iptables jshn jsonfilter kernel kmod-bnx2 kmod-button-hotplug kmod-e1000 \
kmod-e1000e kmod-forcedeth kmod-fs-vfat kmod-igb kmod-input-core kmod-ip6tables kmod-ipt-conntrack \
kmod-ipt-core kmod-ipt-nat kmod-ipt-offload kmod-ixgbe kmod-lib-crc-ccitt kmod-nf-conntrack kmod-nf-conntrack6 \
kmod-nf-flow kmod-nf-ipt kmod-nf-ipt6 kmod-nf-nat kmod-nf-reject kmod-nf-reject6 kmod-nls-base kmod-nls-cp437 \
kmod-nls-iso8859-1 kmod-nls-utf8 kmod-ppp kmod-pppoe kmod-pppox kmod-r8169 kmod-slhc kmod-usb-net-rtl8152 \
libblkid libblobmsg-json libc libcomerr libext2fs libf2fs libip4tc libip6tc libiwinfo libiwinfo-data libiwinfo-lua \
libjson-c libjson-script liblua liblucihttp liblucihttp-lua libnl-tiny libsmartcols libss libubox libubus \
libubus-lua libuci libuclient libustream-wolfssl libuuid libwolfssl libxtables logd lua luci luci-app-banip \
luci-app-firewall luci-app-opkg luci-app-sqm luci-app-upnp luci-base luci-lib-base luci-lib-ip luci-lib-jsonc \
luci-lib-nixio luci-mod-admin-full luci-mod-network luci-mod-status luci-mod-system luci-proto-ipv6 luci-proto-ppp \
luci-ssl luci-theme-bootstrap mkf2fs mtd nano netifd odhcp6c odhcpd-ipv6only openwrt-keyring opkg partx-utils ppp \
ppp-mod-pppoe procd px5g-wolfssl rpcd rpcd-mod-file rpcd-mod-iwinfo rpcd-mod-luci rpcd-mod-rrdns ubox ubus ubusd uci \
uclient-fetch uhttpd uhttpd-mod-ubus urandom-seed urngd usign parted gdisk lsblk losetup resize2fs \
block-mount fdisk samba4-server samba4-libs luci-app-samba4 openssh-sftp-client openssh-sftp-server \
bash luci-theme-bootstrap kmod-usb-storage kmod-usb-storage-extras kmod-usb-storage-uas usbutils git git-http jq \
kmod-usb-ohci kmod-usb-uhci kmod-fs-exfat kmod-fs-ext4 kmod-usb-core kmod-usb2 kmod-usb3 ntfs-3g hdparm f2fsck mount-utils \
kmod-fs-squashfs squashfs-tools-unsquashfs squashfs-tools-mksquashfs kmod-fs-f2fs kmod-fs-vfat" \
FILES="${BASEDIR}/files/" \
BIN_DIR="${OUTPUT}"
