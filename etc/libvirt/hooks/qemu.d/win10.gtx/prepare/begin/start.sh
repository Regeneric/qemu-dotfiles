#!/bin/bash
# Helpful to read output when debugging
set -x

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

modprobe -r nvidia_drm
modprobe -r nvidia_modeset
morprobe -r nvidia_uvm
modprobe -r nvidia

modprobe -r ipmi_devintf
modprobe -r ipmi_msghandler

# Unbind the GPU from display driver
virsh nodedev-detach pci_0000_06_00_0
virsh nodedev-detach pci_0000_06_00_1

# Load VFIO Kernel Module  
modprobe vfio-pci 
