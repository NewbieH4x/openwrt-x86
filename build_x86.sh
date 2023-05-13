#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="21.02.7"
BUILDER="https://downloads.openwrt.org/releases/${BUILD_VERSION}/targets/x86/64/openwrt-imagebuilder-${BUILD_VERSION}-x86-64.Linux-x86_64.tar.xz"
KERNEL_PARTSIZE=200 #Kernel-Partitionsize in MB
ROOTFS_PARTSIZE=3096 #Rootfs-Partitionsize in MB
BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/

# clean previous images
make clean

# Packages are added if no prefix is given, '-packaganame' does not integrate a package
sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=$KERNEL_PARTSIZE/g" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE/g" .config

make image PROFILE="generic" \
PACKAGES="adblock \
	base-files \
	bash \
	beep \
	block-mount \
	busybox \
	ca-bundle \
	cgi-io \
	curl \
	debootstrap \
	diffutils \
	dnsmasq \
	dropbear \
	e2fsprogs \
	ethtool \
	f2fsck \
	fdisk \
	file \
	firewall \
	fstools \
	fwtool \
	gdisk \
	getrandom \
	git \
	git-http \
	grub2 \
	grub2-efi \
	hdparm \
	hostapd \
	htop \
	ip6tables \
	iperf3 \
	iptables \
	irqbalance \
	jq \
	jshn \
	jsonfilter \
	kernel \
	kmod-bnx2 \
	kmod-button-hotplug \
	kmod-cfg80211 \
	kmod-e1000 \
	kmod-e1000e \
	kmod-forcedeth \
	kmod-fs-exfat \
	kmod-fs-ext4 \
	kmod-fs-f2fs \
	kmod-fs-squashfs \
	kmod-fs-vfat \
	kmod-igb \
	kmod-input-core \
	kmod-ip6tables \
	kmod-ipt-conntrack \
	kmod-ipt-core \
	kmod-ipt-nat \
	kmod-ipt-offload \
	kmod-ixgbe \
	kmod-lib80211 \
	kmod-lib-crc-ccitt \
	kmod-mac80211 \
	kmod-nf-conntrack \
	kmod-nf-conntrack6 \
	kmod-nf-flow \
	kmod-nf-ipt \
	kmod-nf-ipt6 \
	kmod-nf-nat \
	kmod-nf-reject \
	kmod-nf-reject6 \
	kmod-nls-base \
	kmod-nls-cp437 \
	kmod-nls-iso8859-1 \
	kmod-nls-utf8 \
	kmod-ppp \
	kmod-pppoe \
	kmod-pppox \
	kmod-r8169 \
	kmod-rt2800-usb \
	kmod-rtl8187 \
	kmod-rtl8192ce \
	kmod-rtl8192cu \
	kmod-rtl8192de \
	kmod-rtl8xxxu \
	kmod-slhc \
	kmod-usb3 \
	kmod-usb-core \
	kmod-usb-net-asix-ax88179 \
	kmod-usb-net-cdc-ether \
	kmod-usb-net-ipheth \
	kmod-usb-net-rtl8152 \
	kmod-usb-ohci \
	kmod-usb-storage \
	kmod-usb-storage-extras \
	kmod-usb-storage-uas \
	kmod-usb-uhci \
	kmod-usb-wdm \
	less \
	libblkid \
	libblobmsg-json \
	libc \
	libcomerr \
	libext2fs \
	libf2fs \
	libip4tc \
	libip6tc \
	libiwinfo \
	libiwinfo-data \
	libiwinfo-lua \
	libjson-c \
	libjson-script \
	liblua \
	liblucihttp \
	liblucihttp-lua \
	libnl-tiny \
	libsmartcols \
	libss \
	libubox \
	libubus \
	libubus-lua \
	libuci \
	libuclient \
	libustream-wolfssl \
	libuuid \
	libwolfssl \
	libxtables \
	logd \
	losetup \
	lsblk \
	lsof \
	lua \
	luci \
	luci-app-adblock \
	luci-app-banip \
	luci-app-firewall \
	luci-app-minidlna \
	luci-app-openvpn \
	luci-app-opkg \
	luci-app-samba4 \
	luci-app-sqm \
	luci-app-ttyd \
	luci-app-uhttpd \
	luci-app-upnp \
	luci-app-wireguard \
	luci-base \
	luci-compat \
	luci-lib-base \
	luci-lib-ip \
	luci-lib-ipkg \
	luci-lib-jsonc \
	luci-lib-nixio \
	luci-mod-admin-full \
	luci-mod-network \
	luci-mod-status \
	luci-mod-system \
	luci-proto-ipv6 \
	luci-proto-ppp \
	luci-ssl \
	luci-theme-bootstrap \
	mc \
	minidlna \
	mkf2fs \
	mount-utils \
	mtd \
	nano \
	netifd \
	netperf \
	ntfs-3g \
	odhcp6c \
	odhcpd-ipv6only \
	openssh-sftp-client \
	openssh-sftp-server \
	openvpn-openssl \
	openwrt-keyring \
	opkg \
	parted \
	partx-utils \
	ppp \
	ppp-mod-pppoe \
	procd \
	px5g-wolfssl \
	resize2fs \
	rpcd \
	rpcd-mod-file \
	rpcd-mod-iwinfo \
	rpcd-mod-luci \
	rpcd-mod-rrdns \
	rsync \
	rt2800-usb-firmware \
	rtl8188eu-firmware \
	samba4-libs \
	samba4-server \
	speedtest-netperf \
	squashfs-tools-mksquashfs \
	squashfs-tools-unsquashfs \
	tree \
	ubox \
	ubus \
	ubusd \
	uci \
	uclient-fetch \
	uhttpd \
	uhttpd-mod-ubus \
	urandom-seed \
	urngd \
	usbmuxd \
	usbutils \
	usign \
	vpn-policy-routing \
	watchcat \
	wget \
	wg-installer-client \
	wireguard-tools \
	wireless-regdb \
	wpa-cli \
	wpa-supplicant \
	zlib" \
FILES="${BASEDIR}/files/" \
BIN_DIR="${OUTPUT}"
