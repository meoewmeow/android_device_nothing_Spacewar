#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
TARGET_SUPPORTS_OMX_SERVICE := false
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from Spacewar device
$(call inherit-product, device/nothing/Spacewar/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Google apps (MindTheGapps, Android 16 "baklava"), replacing microG. Plain
# inherit-product on purpose: a missing vendor/gapps must fail the build rather
# than silently ship a ROM without Google. WITH_GMS also drops the product
# partition space Lineage otherwise reserves for flashing GApps later.
WITH_GMS := true
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)

# vendor/addons installs its own google.xml as google-addons.xml (renamed there) so
# it does not collide with MindTheGapps' Soong module of the same name. Both files
# are kept: sysconfig reads every XML in the directory. (Filtering PRODUCT_PACKAGES
# here cannot work: inherit-product is deferred until after this file is read.)

# MindTheGapps supplies libjni_latinimegoogle; don't also require the
# same-named prebuilt bundled with AOSP LatinIME.
SOONG_CONFIG_NAMESPACES += lineage_cuttlefish
SOONG_CONFIG_lineage_cuttlefish += disable_latinime_google_jni
SOONG_CONFIG_lineage_cuttlefish_disable_latinime_google_jni := true

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := lineage_Spacewar
PRODUCT_DEVICE := Spacewar
PRODUCT_BRAND := Nothing
PRODUCT_MODEL := A063
PRODUCT_MANUFACTURER := Nothing

PRODUCT_CHARACTERISTICS := nosdcard

PRODUCT_GMS_CLIENTID_BASE := android-nothing

PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceProduct=Spacewar \
    BuildFingerprint="Nothing/Spacewar/Spacewar:15/AQ3A.240929.001/2604161140:user/release-keys"

# Blur
TARGET_ENABLE_BLUR := true

# Boot Animation
TARGET_BOOT_ANIMATION_RES := 1080

# adb_root (the adbroot_service behind `adb root`) is gated behind WITH_SU in
# vendor/lineage/config/common.mk, which is off by default.
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += adb_root
endif
