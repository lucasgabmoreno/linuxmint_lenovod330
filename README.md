# Linux in Lenovo IdeaPad D330
- OS: Linux Mint Debian Edition 5 x86_64 (Updated to LMDE6).
- Kernel: 5.10.0-12-amd64 (Replaced with last 5.4.x-generic mainline).
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
3. Create USB Installer with [Linux Mint Debian Edition 5](https://linuxmint.com/edition.php?id=297) ([Alternative link](https://web.archive.org/web/20230529054534/https://www.linuxmint.com/edition.php?id=297)).
4. Boot from USB Installer<br>
> If blank screen, reboot again and again until working screen.<br>
> You will notice your screen in portrait orientation. Don't try to rotate in Display options, will make black screen.
5. If you have a micro SD card for home partition, [convert it to GPT System Partition](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/GPT.md).
6. If you have micro SD, use this partition map:<br>
```
Internal storage:
/EFI boot partition 1024 MB logic  (Flags: boot, esp)
/ (root) (use all free space) logic
/swap 2048 MB

Micro SD card:
/home (use all free space) logic
```
> Otherwise, let Linux Mint installer automatically manage partitions on internal storage.

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
3. Install and config
```
# Upgrade
sudo apt update -y && sudo apt upgrade -y
# Dependencies and fixes
sudo apt install grub-customizer inotify-tools iio-sensor-proxy mesa-utils git v4l-utils -y
# Refresh screen
sudo wget -O /usr/bin/lenovod330-refreshscreen.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-refreshscreen.sh
sudo chmod +x /usr/bin/lenovod330-refreshscreen.sh
# Make Xorg dir
sudo mkdir -v /etc/X11/xorg.conf.d
# Create xorg files
echo -e 'Section "ServerFlags"\n Option "BlankTime" "0"\n Option "StandbyTime" "0"\n Option "SuspendTime" "0"\n Option "OffTime" "0"\n Option "dpms" "false"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/10-xorg.conf
echo -e 'Section "Device"\n Identifier "Intel Graphics"\n Driver "Intel"\n Option "DRI" "3"\n Option "AccelMethod" "sna"\n Option "TearFree" "true"\n Option "VSync" "false"\n Option "TripleBuffer" "false"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf
echo -e '# IdeaPad D330-10IGM (both 81H3 and 81MD product names)\nsensor:modalias:acpi:BOSC0200*:dmi:*:svnLENOVO:*:pvrLenovoideapadD330-10IGM:*\n ACCEL_MOUNT_MATRIX=0, 1, 0; -1, 0, 0; 0, 0, 1\n\n# IdeaPad D330-10IGL(82H0)\nsensor:modalias:acpi:BOSC0200*:dmi:*:svnLENOVO:*:pvrLenovoideapadD330-10IGL:*\n ACCEL_MOUNT_MATRIX=0, 1, 0; -1, 0, 0; 0, 0, 1' | sudo tee /etc/udev/hwdb.d/61-sensor-local.hwdb
# Reset sensors
sudo systemd-hwdb update
sudo udevadm trigger -v -p DEVNAME=/dev/iio:device0
sudo service iio-sensor-proxy restart
# Firefox gestures fix
echo export MOZ_USE_XINPUT2=1 | sudo tee /etc/profile.d/use-xinput2.sh
```
3. Go to [Ubuntu's Kernel Mainline](https://kernel.ubuntu.com/~kernel-ppa/mainline/) and download the last 5.4.x generic amd64 files and install
```
sudo dpkg -i linux*.deb
```
4. Open `Keyboard Settings` > `Shortcuts` > `Custom Shortcuts` > Add new one called `Refresh Screen` > Use `/usr/bin/lenovod330-refreshscreen.sh` > Add a shortcut like `Ctrl+Shift+R`
5. Upgrade to Linux Mint Debian Edition 6:
```
sudo apt update -y && sudo apt install mintupgrade -y && sudo mintupgrade
```
Go to options (ⵗ) and disable Timeshift then upgrade.

6. Open `Grub Customizer` and move installed kernel at first, remove 5.10 and 6.1 but don't uninstall
> When mintupdate ask you to upgrade 5.10 or 6.1 kernel, left click and disable future upgrades

---

### Black Screen fix
- Notebook mode: Press Ctrl+Shift+R until working screen.
- Tablet mode: Rotate device until working screen.

### Battery
1. Download and install auto-cpufreq:
```
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
```
2. Choose Option "i".
3. Run daemon:
```
sudo auto-cpufreq --install
```

### Webcam
You can set front camera as default or remove back camera.<br>
For setting front camera as default, add these files:
```
sudo wget -O /etc/systemd/system/lenovod330-webcam-default.service https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-webcam-default.service
sudo wget -O /usr/bin/lenovod330-webcam-default.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-webcam-default.sh
sudo chmod +x /etc/systemd/system/lenovod330-webcam-default.service
sudo chmod +x /usr/bin/lenovod330-webcam-default.sh
sudo systemctl enable lenovod330-webcam-default.service
sudo systemctl start lenovod330-webcam-default.service
```
For removing back camera, add these files:
```
sudo wget -O /etc/systemd/system/lenovod330-webcam-remove.service https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-webcam-remove.service
sudo wget -O /usr/bin/lenovod330-webcam-remove.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-webcam-remove.sh
sudo chmod +x /etc/systemd/system/lenovod330-webcam-remove.service
sudo chmod +x /usr/bin/lenovod330-webcam-remove.sh
sudo systemctl enable lenovod330-webcam-remove.service
sudo systemctl start lenovod330-webcam-remove.service
```

### Multitouch
Install [Touchegg](https://github.com/JoseExposito/touchegg/releases/latest).


### Touchpad

Open `Keyboard Settings` > `Shortcuts` > `System` > `Hardware` > Find `Toggle Touchpad state` > Add this shortcut `Fn+Supr` (Ctrl+Supr0xca)

### ACPI
For [ACPI startup error](ACPI.md), open LMDE grub configuration file:
```
sudo xed /etc/default/grub.d/50_lmde.cfg
```
GRUB_CMDLINE_LINUX_DEFAULT must look like this:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 fbcon=nodefer video=efifb:nobgrt"
```
Open `Grub Customizer` > `General settings` > `kernel parameters`, and set:
```
quite splash loglevel=3 fbcon=nodefer video=efifb:nobgrt
```
> Into grub, don't use "Debian GNU/Linux" default as first option. It won't take kernel parameter. Use "Debian GNU/Linux, with Linux 5.4.*" instead.

### Browsers
To fix browser freeze use [this Browser Freeze Fix](https://github.com/lucasgabmoreno/browserfreezefix)

---

### Credits:
- [Lenovo Support](https://support.lenovo.com)
- [Lenovo Forums](https://forums.lenovo.com/t5/Ubuntu/Linux-on-Ideapad-D330/m-p/4296738)
- [Microsoft Support](https://support.microsoft.com)
- [Linux Mint Forum](https://forums.linuxmint.com)
- [Ubuntu Kernel PPA](https://kernel.ubuntu.com/~kernel-ppa/mainline/)
- [Karla](https://youtu.be/vFA-phErf9o)
- [Rojtberg](https://www.rojtberg.net/1652/ubuntu-on-the-lenovo-d330/)
- [Markus](https://gist.github.com/Links2004/5976ce97a14dabf773c3ff98d03c0f61)
- [Angelo](https://unixcop.com/fix-the-error-cant-find-the-command-hwmatch-on-grub/)
- [Archlinux](https://wiki.archlinux.org/title/xrandr#Screen_Blinking)
- FreeDesktop [109267](https://bugs.freedesktop.org/show_bug.cgi?id=109267) [108826](https://bugs.freedesktop.org/show_bug.cgi?id=108826)
- [LinuxCapable](https://www.linuxcapable.com/es/how-to-install-linux-kernel-5-17-on-linux-mint-20-lts/)
- [Launchpad](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1838373)
- [vvFiCKvv](https://github.com/vvFiCKvv)
- [Damien1307](https://forums.linuxmint.com/viewtopic.php?p=1711509&sid=ceee8993543ad8a19c2f478fe8c74826#p1711509)
- [AdnanHodzic](https://github.com/AdnanHodzic/auto-cpufreq)
- [Kevin Becker](https://kevinbecker.org/blog/category/linux)
