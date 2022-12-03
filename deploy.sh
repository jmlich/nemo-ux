#!/bin/bash

if [[ "$(whoami)" != "${BUILD_USER-root}" ]]; then
    echo "Error: This script must be run with ${BUILD_USER-root} priveleges" >&2
    exit 1
fi

function build_aarch64_fn() {
    rm /var/lib/manjaro-arm-tools/pkg/aarch64/var/cache/pacman/pkg/*
    buildarmpkg -k -p $*
    rsync /var/cache/manjaro-arm-tools/pkg/aarch64/ /var/lib/manjaro-arm-tools/pkg/aarch64/srv/repo/ -r
    rm /var/lib/manjaro-arm-tools/pkg/aarch64/srv/repo/selfbuild.db.tar.xz
    repo-add /var/lib/manjaro-arm-tools/pkg/aarch64/srv/repo/selfbuild.db.tar.xz /var/lib/manjaro-arm-tools/pkg/aarch64/srv/repo/*.zst
    manjaro-chroot /var/lib/manjaro-arm-tools/pkg/aarch64/ pacman -Syyu --noconfirm
}

if [ "$BUILDARCH" == "aarch64" ]; then
    echo "Build for arm64 arch"
    BUILD="${BUILD-build_aarch64_fn}"
else
    echo "Build for $(uname -m) arch"
    BUILD="${BUILD-buildpkg -n -p}"
fi

# NemoMobile packages
eval "$BUILD nemo-theme-glacier"
eval "$BUILD abseil-cpp"

if [ "$BUILDARCH" != "aarch64" ]; then
eval "$BUILD libphonenumber"
fi
eval "$BUILD libglibutil"
eval "$BUILD libwspcodec"
eval "$BUILD libdbusaccess"
eval "$BUILD libdbuslog"
eval "$BUILD ofono"

eval "$BUILD nemo-qml-plugin-dbus"
eval "$BUILD geoclue1"
eval "$BUILD nemo-qml-plugin-settings"
eval "$BUILD nemo-qml-plugin-folderlistmodel"
eval "$BUILD libresource"
eval "$BUILD libresourceqt"
eval "$BUILD qtmpris"
eval "$BUILD mce-headers"
eval "$BUILD libdsme"
eval "$BUILD libiphb"
eval "$BUILD nemo-keepalive"
eval "$BUILD nemo-qml-plugin-devicelock"
eval "$BUILD glacier-devicelock-plugin"
eval "$BUILD mlite"
eval "$BUILD nemo-qml-plugin-thumbnailer"
eval "$BUILD qtdocgallery"
eval "$BUILD nemo-qml-plugin-configuration"
eval "$BUILD nemo-qml-plugin-statusnotifier"
eval "$BUILD libiodata"
eval "$BUILD sailfish-access-control"
eval "$BUILD tzdata-timed"
eval "$BUILD timed"
eval "$BUILD nemo-qml-plugin-time"
eval "$BUILD qt5-pim"
eval "$BUILD libmlocale"
eval "$BUILD nemo-qml-plugin-models"
eval "$BUILD libngf"
eval "$BUILD usb-moded"
eval "$BUILD mce"
eval "$BUILD libmce-qt"
eval "$BUILD buteo-syncfw"
eval "$BUILD sensorfw"
eval "$BUILD qt5-sensors-sensorfw"
eval "$BUILD qtcontacts-sqlite"
eval "$BUILD nemo-qml-plugin-notifications"
eval "$BUILD libqofono-qt5"
eval "$BUILD libqofonoext"
eval "$BUILD libconnman-qt"
eval "$BUILD geoclue1-providers-mlsdb"
eval "$BUILD libngf-qt"
eval "$BUILD libusb-moded-qt"
eval "$BUILD profiled-settings-nemo"
eval "$BUILD profiled"
eval "$BUILD qt5-systems"
eval "$BUILD nemo-qml-plugin-systemsettings"
eval "$BUILD buteo-mtp"
eval "$BUILD nemo-qml-plugin-connectivity"
eval "$BUILD buteo-sync-plugin-carddav"
eval "$BUILD nemo-qml-plugin-contacts"
eval "$BUILD libprofile-qt"
eval "$BUILD qt-mobility-haptics-ffmemless"
eval "$BUILD pulsecore-headers"
eval "$BUILD pulseaudio-module-keepalive"
eval "$BUILD dsme"
eval "$BUILD swi-prolog7"
eval "$BUILD libprolog"
eval "$BUILD libtrace-ohm"
eval "$BUILD mce-plugin-libhybris-nondroid"
eval "$BUILD ohm"
eval "$BUILD libdres-ohm"
eval "$BUILD policy-settings-common"
eval "$BUILD ohm-plugins-misc"
eval "$BUILD ohm-rule-engine"
eval "$BUILD fingerterm"
eval "$BUILD ngfd"
eval "$BUILD ngfd-settings-nemo"
eval "$BUILD ngfd-plugin-native-vibrator"
eval "$BUILD libcommhistory"
eval "$BUILD commhistory-daemon"
eval "$BUILD qmf-qt5"
eval "$BUILD nemo-qml-plugin-accounts"
eval "$BUILD nemo-qml-plugin-messages"
eval "$BUILD mkcal"
eval "$BUILD contactsd"
eval "$BUILD telepathy-mission-control"
eval "$BUILD voicecall"
eval "$BUILD nemo-qml-plugin-email"
eval "$BUILD usb-tethering"
eval "$BUILD qt5-feedback-haptics-native-vibrator"
eval "$BUILD libsocialcache"
eval "$BUILD buteo-sync-plugins-social"
eval "$BUILD nemo-qml-plugin-alarms"
eval "$BUILD nemo-qml-plugin-calendar"
eval "$BUILD nemo-qml-plugin-fingerprint"
eval "$BUILD nemo-qml-plugin-signon"
eval "$BUILD presage2"
eval "$BUILD presage2-lang"

#Glacier UX packages
eval "$BUILD nemo-theme-openmoko"
eval "$BUILD google-opensans-fonts"
eval "$BUILD qt5-glacier-app"
eval "$BUILD qt5-quickcontrols-nemo"
eval "$BUILD glacier-calc"
eval "$BUILD glacier-filemuncher"
eval "$BUILD glacier-camera"
eval "$BUILD glacier-music"
eval "$BUILD glacier-polkit-agent"
eval "$BUILD glacier-packagemanager"
eval "$BUILD glacier-gallery"
eval "$BUILD qt5-quickcontrols-nemo-examples"
eval "$BUILD glacier-pinquery"
eval "$BUILD qt5-lipstick"
eval "$BUILD glacier-settings"
eval "$BUILD maliit-nemo-keyboard"
eval "$BUILD maliit-input-context-gtk"
eval "$BUILD glacier-testtool"
eval "$BUILD lipstick-glacier-home"
eval "$BUILD glacier-wayland-session"
eval "$BUILD glacier-contacts"
eval "$BUILD glacier-messages"
eval "$BUILD glacier-dialer"
eval "$BUILD glacier-mail"
eval "$BUILD glacier-browser"
eval "$BUILD glacier-weather"
eval "$BUILD glacier-calendar"
eval "$BUILD glacier-alarmclock"
eval "$BUILD glacier-alarm-listener"
eval "$BUILD glacier-settings-accounts"
eval "$BUILD glacier-settings-developermode"

# pure-maps packages
if [ "$BUILDARCH" != "aarch64" ]; then
    eval "$BUILD python-otherside"
fi
eval "$BUILD gpxpy"
eval "$BUILD s2geometry"
eval "$BUILD maplibre-gl-native"
eval "$BUILD mapbox-gl-qml"
eval "$BUILD pure-maps"

# arm specific packages
if [ "$BUILDARCH" == "aarch64" ]; then
    eval "$BUILD bootsplash-theme-nemo" # for x86_64 plymouth-theme-
    eval "$BUILD hybris/android-headers"
    eval "$BUILD hybris/libhybris"
    eval "$BUILD hybris/qt5-qpa-hwcomposer-plugin"

    eval "$BUILD devices/nemo-device-pinephone"
    eval "$BUILD devices/nemo-device-pinetab"

    eval "$BUILD cutiepi-kernel-config"
    eval "$BUILD cutiepi-cutoff"
    eval "$BUILD devices/nemo-device-cutiepi"
fi
