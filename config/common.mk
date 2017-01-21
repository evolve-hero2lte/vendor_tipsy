PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Default sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Alya.ogg \
    ro.config.notification_sound=Tethys.ogg

# NexusLauncher
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/NexusLauncher/NexusLauncher.apk:system/app/NexusLauncher/NexusLauncher.apk

# Wallpaper
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/Wallpaper/Wallpaper.apk:system/app/Wallpaper/Wallpaper.apk

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/tipsy/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/tipsy/prebuilt/common/bin/50-tipsy.sh:system/addon.d/50-tipsy.sh

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Tipsy-specific init file
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/etc/init.local.rc:root/init.tipsy.rc

# Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/tipsy/overlay/dictionaries

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/tipsy/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/tipsy/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/tipsy/prebuilt/common/bin/sysinit:system/bin/sysinit

# debug packages
ifneq ($(TARGET_BUILD_VARIENT),user)
PRODUCT_PACKAGES += \
    Development
endif

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam \
    BluetoothExt \
    KernelAdiutor \
    LatinIME \
    LockClock \
    masquerade \
    Tavern

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# AudioFX
PRODUCT_PACKAGES += \
    AudioFX

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml


ifneq ($(DISABLE_SLIM_FRAMEWORK), true)
## Slim Framework
include frameworks/opt/slim/slim_framework.mk
endif

## Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/tipsy/overlay/common

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/tipsy/overlay/dictionaries


PRODUCT_COPY_FILES += \
    vendor/tipsy/prebuilt/common/bootanimation/bootanimation.zip:system/media/bootanimation.zip


# Versioning System
# Evolve version.
PRODUCT_VERSION_MAJOR = 7.1.1
PRODUCT_VERSION_MINOR =
PRODUCT_VERSION_MAINTENANCE = v1
ifdef TIPSY_BUILD_EXTRA
    TIPSY_POSTFIX := $(TIPSY_BUILD_EXTRA)
endif
ifndef TIPSY_BUILD_TYPE
    TIPSY_BUILD_TYPE := Release
    TIPSY_POSTFIX := $(shell date +"%Y%m%d-%H%M")
endif

# Set all versions
TIPSY_VERSION := Evolve-$(TIPSY_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(TIPSY_POSTFIX)
TIPSY_MOD_VERSION := Evolve-$(TIPSY_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(TIPSY_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    tipsy.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(shell date) \
    ro.tipsy.version=$(TIPSY_VERSION) \
    ro.modversion=$(TIPSY_MOD_VERSION) \
    ro.tipsy.buildtype=$(TIPSY_BUILD_TYPE)

EXTENDED_POST_PROCESS_PROPS := vendor/tipsy/tools/tipsy_process_props.py

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/data/cache
else
  ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.device.cache_dir=/cache
endif
