#!/bin/bash
# Helpful to read output when debugging
set -x

chmod -R 775 /dev/vfio
chown -R root:hkk /dev/vfio

# Stop display manager
systemctl stop gdm.service
killall gdm-x-session

# Unbind VTconsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

# Unbind EFI-Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 2

modprobe -r drm_buddy
modprobe -r intel_gtt
modprobe -r video
modprobe -r drm_display_helper
modprobe -r cec
modprobe -r ttm
modprobe -r i915

modprobe -r ipmi_devintf
modprobe -r ipmi_msghandler

# Unbind the GPU from display driver
virsh nodedev-detach pci_0000_08_00_0	# GPU
virsh nodedev-detach pci_0000_09_00_0	# Audio

# Load VFIO Kernel Module  
modprobe vfio
modprobe vfio-pci 
modprobe vfio_iommu_type1
