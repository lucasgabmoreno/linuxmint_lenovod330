# Linux in Lenovo IdeaPad D330
- OS: Linux Mint Debian Edition 6 x86_64.
- Kernel: 5.4.x
- Issues can't fix: random blank screen at boot or when rotate screen.
> (Other distros, kernels and drivers may not work, cause flickering screen or permanent blank screen).

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

1. Optional: [Make a Windows Backup](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/WINDOWS.md#windows-backup) and [Update BIOS and Firmware](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/WINDOWS.md#update-bios-and-firmware).
2. Go to BIOS options and disable Secure Boot.
3. Create USB Installer with [Linux Mint Debian Edition modded for Lenovo D330](https://sourceforge.net/projects/lmde6-d330/files/) or [create your own Respin.](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/RESPIN.md)
4. Boot from USB Installer<br>
> If blank screen, reboot again and again until working screen.<br>
> You will notice your screen in portrait orientation. Don't try to rotate in Display options, will make black screen.
5. If you have a micro SD card for home partition, run Gparted (pass:evolution) and [convert it to GPT System Partition](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/GPT.md).
6. If you have micro SD, use this partition map using Gparted (pass:evolution):<br>
```
Internal storage:
/EFI boot partition 1024 MB logic  (Flags: boot, esp)
/ (root) (use all free space) logic
/swap 2048 MB

Micro SD card:
/home (use all free space) logic
```
> Otherwise, let Calamares manage partitions on internal storage.
7. Run Calamares and install
---

## Postinstall

1. Start Linux Mint, if black screen, reboot again and again until screen works.
2. Disable hibernate and suspend options, it may cause blank screen.
- Open Power Managment and disable all hibernate and suspend options to "never" or "do nothing".
- Open Screensaver and disable suspend option.
3. Open terminal and switch to admin
```
sudo echo "Admin"
```
4. Install and config
```
# Remove eggs
sudo apt purge eggs -y
# Create xorg files
echo -e 'Section "ServerFlags"\n Option "BlankTime" "0"\n Option "StandbyTime" "0"\n Option "SuspendTime" "0"\n Option "OffTime" "0"\n Option "dpms" "false"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/10-xorg.conf
echo -e 'Section "Device"\n Identifier "Intel Graphics"\n Driver "Intel"\n Option "DRI" "3"\n Option "AccelMethod" "sna"\n Option "TearFree" "true"\n Option "VSync" "false"\n Option "TripleBuffer" "false"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf
echo -e '# IdeaPad D330-10IGM (both 81H3 and 81MD product names)\nsensor:modalias:acpi:BOSC0200*:dmi:*:svnLENOVO:*:pvrLenovoideapadD330-10IGM:*\n ACCEL_MOUNT_MATRIX=0, 1, 0; -1, 0, 0; 0, 0, 1\n\n# IdeaPad D330-10IGL(82H0)\nsensor:modalias:acpi:BOSC0200*:dmi:*:svnLENOVO:*:pvrLenovoideapadD330-10IGL:*\n ACCEL_MOUNT_MATRIX=0, 1, 0; -1, 0, 0; 0, 0, 1' | sudo tee /etc/udev/hwdb.d/61-sensor-local.hwdb
# Reset sensors
sudo systemd-hwdb update
sudo udevadm trigger -v -p DEVNAME=/dev/iio:device0
sudo service iio-sensor-proxy restart
```
5. Open `Keyboard Settings` > `Shortcuts` > `Custom Shortcuts` > Add new one called `Refresh Screen` > Use `/usr/bin/lenovod330-refreshscreen.sh` > Add a shortcut like `Ctrl+Shift+R`

---

### Black Screen fix
- Notebook mode: Press Ctrl+Shift+R until working screen.
- Tablet mode: Rotate device until working screen.

---

### Battery
1. Run auto-cpufreq daemon:
```
sudo auto-cpufreq --install
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

### Browsers
Add `/usr/bin/browserfreezefix.sh` to Startup

---

### Upgrade Kernel 5.4.x
1. Install Maniline
```
sudo apt install libgee-0.8-dev libjson-glib-dev libvte-2.91-dev valac aria2 lsb-release make gettext dpkg-dev
git clone https://github.com/bkw777/mainline.git
cd mainline
make
sudo make install
```
2. Upgrade
```
KERNEL=$(grep ^5.4 <<< $(mainline list --previous-majors all))
mainline install $(echo "${KERNEL}" | head -1) --include-all
mainline uninstall-old
```
