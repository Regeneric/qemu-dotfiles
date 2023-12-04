#!/bin/bash
set -x
  
# Re-Bind GPU to Intel Driver
virsh nodedev-reattach pci_0000_08_00_0
virsh nodedev-reattach pci_0000_09_00_0

# Reload nvidia modules
modprobe drm_buddy
modprobe intel_gtt
modprobe video
modprobe drm_display_helper
modprobe cec
modprobe ttm
modprobe i915

modprobe ipmi_devintf
modprobe ipmi_msghandler

# Rebind VT consoles
echo 1 > /sys/class/vtconsole/vtcon0/bind
# Some machines might have more than 1 virtual console. Add a line for each corresponding VTConsole
#echo 1 > /sys/class/vtconsole/vtcon1/bind

#nvidia-xconfig --query-gpu-info > /dev/null 2>&1
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Restart Display Manager
systemctl start gdm.service
