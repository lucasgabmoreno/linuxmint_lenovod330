# Linux in Lenovo IdeaPad D330

- Linux Mint Debian Edition 7 x86_64.
- Kernel: 6.12.x

---

## Devices
| &nbsp; | 81H3 | 81MD | 82H0 | 
| :--- | :--- | :--- | :--- |
| Model | Lenovo IdeaPad D330-10IGM | Lenovo IdeaPad D330-10IGM | Lenovo IdeaPad D330-10IGL |
| Proccesor | Pentium | Celeron | Celeron |
| Graphics | UHD Graphics 605 | UHD Graphics 600 | UHD Graphics 605 |
| Resolution | 1920x1200 | 800x1280 | 800x1280 |
| Quality | FHD | HD | HD |
| Storage | 128 | 64 | 64 |
| RAM | 4 | 4 | 4 |

---

- BIOS: Turn off [10 sec power button] > Turn on [5 sec power button] > `Fn+F2`.<br>
- Boot Options: Turn off > Turn on > `Fn+F12`.

---

## Install

1. Go to BIOS options and disable Secure Boot.
3. Create USB Installer with [Linux Mint Debian Edition](https://linuxmint.com/download_lmde.php)
3. Boot from USB Installer<br>
> If blank screen, reboot again and again until working screen.<br>
4. If you have a microSD card, you can expand your storage by using it as the `/home` partition. Run Gparted and [convert it to GPT System Partition](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/GPT.md).<br>
```
Internal storage:
/EFI boot partition 1024 MB logic  (Flags: boot, esp)
/ (root) (use all free space) logic
/swap 2048 MB
```
7. Run Linux Mint Installer and install
---

## Postinstall

1. Start Linux Mint, if black screen, reboot again and again until screen works.
2. If the fix I submitted in [issue #13225](https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/13225) has already been applied upstream, simply update your kernel. Otherwise, please install the patched kernel available in the [Releases section](https://github.com/lucasgabmoreno/linuxmint_lenovod330/releases).
3. Run Terminal and apply some fixes:
```
# Firefox Gestures Fix
echo export MOZ_USE_XINPUT2=1 | sudo tee /etc/profile.d/use-xinput2.sh

# Tear Free and Accelerometer orientation
echo -e 'Section "ServerFlags"\n Option "BlankTime" "0"\n Option "StandbyTime" "0"\n Option "SuspendTime" "0"\n Option "OffTime" "0"\n Option "dpms" "false"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/10-xorg.conf
echo -e 'Section "Device"\n Identifier "Intel Graphics"\n Driver "Intel"\n Option "DRI" "3"\n Option "AccelMethod" "sna"\n Option "TearFree" "true"\n Option "VSync" "false"\n Option "TripleBuffer" "false"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf
echo -e '# IdeaPad D330-10IGM (both 81H3 and 81MD product names)\nsensor:modalias:acpi:BOSC0200*:dmi:*:svnLENOVO:*:pvrLenovoideapadD330-10IGM:*\n ACCEL_MOUNT_MATRIX=0, 1, 0; -1, 0, 0; 0, 0, 1\n\n# IdeaPad D330-10IGL(82H0)\nsensor:modalias:acpi:BOSC0200*:dmi:*:svnLENOVO:*:pvrLenovoideapadD330-10IGL:*\n ACCEL_MOUNT_MATRIX=0, 1, 0; -1, 0, 0; 0, 0, 1' | sudo tee /etc/udev/hwdb.d/61-sensor-local.hwdb

# RAM over swap
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf

# Reset sensors
sudo systemd-hwdb update
sudo udevadm trigger -v -p DEVNAME=/dev/iio:device0
sudo service iio-sensor-proxy restart
```

---

### Webcam
For removing back camera, paste this on terminal:
```
WEBCAM=$(echo $(lsusb | grep Camera\ 5M) | awk -F " " '{print $6; exit}')
ID_VENDOR=$(echo $WEBCAM | awk -F ":" '{print $1; exit}')
ID_PRODUCT=$(echo $WEBCAM | awk -F ":" '{print $2; exit}')
echo -e ACTION\=\=\"add\"\, ATTR\{idVendor\}\=\=\"$ID_VENDOR\"\,\ ATTR\{idProduct\}\=\=\"$ID_PRODUCT\"\,\ RUN\=\"\/bin\/sh \-c\ \'echo\ 1\ \>\/sys\/\\\$devpath\/remove\'\" | sudo tee /etc/udev/rules.d/40-disable-internal-webcam.rules
```

---

### Touchpad
Open `Keyboard Settings` > `Shortcuts` > `System` > `Hardware` > Find `Toggle Touchpad state` > Add this shortcut `Fn+Supr` (Ctrl+Supr0xca)

---

### RAM fixes
```
sudo nano /etc/default/zramswap
```
Change values:
* PERCENT=60
* ALGO=zstd
* ALGORITHM=zstd

Then
```
sudo systemctl restart zramswap
```

---

[ACPI startup error](ACPI.md), open LMDE grub configuration file:
```
sudo xed /etc/default/grub.d/50_lmde.cfg
```
GRUB_CMDLINE_LINUX_DEFAULT must look like this:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 fbcon=nodefer video=efifb:nobgrt"
```
