# Linux Mint in Lenovo IdeaPad D330
This guide is to install Linux Mint in Lenovo IdeaPad D330.<br>
Don't install Linux Mint Ubuntu Edition, it will cause blank screen in grub and flickering screen in recovery mode and nomodeset. Install [LMDE Linux Mint Debian Edition](https://www.linuxmint.com/download_lmde.php) instead.


## Issues
- [No standar BIOS ACPI.](ACPI.md)
- No standar monitor resolution for 800x1280 devices.
- No Legacy BIOS support.
- Xorg random black screen at init or when rotate.


## Device
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

## BIOS
1. Turn off device (10 seconds power button)
2. Turn on device (5 seconds power button)
3. Inmediattely press:
`Fn+F2`


## Boot Options
1. Turn off device
2. Turn on device
3. Inmediattely press:
`Fn+F12`

---

## Disable secure boot
1. [Access BIOS](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/README.md#bios)
2. Disable Secure Boot


## Boot Linux Mint Installer
1. [Access Boot Options](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/README.md#boot-options)
2. Choose USB device<br>
If black screen, reboot again and again until working screen.<br>
You will notice your screen in portrait orientation. Don't force rotate in Display options yet, will make black screen.
3. Optional: [Make a Windows Backup](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/WINDOWS.md#windows-backup).
4. Optional: [Update BIOS and Firmware](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/WINDOWS.md#update-bios-and-firmware).
5. If you have a micro SD card for home partition, [convert it to GPT System Partition](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/GPT.md).
6. Open Installer
7. If you have micro SD, use this partition map:<br>
```
Internal storage:
/EFI boot partition 1024 MB logic  (Flags: boot, esp)
/ (root) (use all free space) logic
/swap 2048 MB

Micro SD card:
/home (use all free space) logic
```
Otherwise, let Linux Mint installer automatically manage partitions on internal storage.<br>
8. Once installed, take off USB device and reboot

---

## Boot Linux Mint
When Grub, choose "recovery mode".<br>
If black screen, reboot again and again until working screen.

## Dependencies
1. Update and Upgrade
```
sudo apt update -y
sudo apt upgrade -y
```
2. Install
```
sudo apt install grub-customizer inotify-tools iio-sensor-proxy mesa-utils git v4l-utils -y
```


## Kernel
1. Download all .deb files from [D330 kernel release](https://github.com/lucasgabmoreno/linuxmint_lenovod330/releases).<br>
Or you can build your own D330 Kernel [following this guide](KERNELBUILD.md) 
2. In the same folder you have downloaded kernel, open terminal and type:
```
sudo dpkg -i linux*.deb
```
4. Open Grub Customizer and move installed kernel at first option.
5. Mintupdate will ask for upadte to a highter kernel. Right click and set something like "ignore all future update of this packages"


## Display
1. Add files:
```
sudo wget -O /usr/bin/lenovod330-10igl-refreshscreen.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-refreshscreen.sh
sudo chmod +x /usr/bin/lenovod330-10igl-refreshscreen.sh
```
2. Open Keyboard Settings > Shortcuts > Custom Shortcuts
- Add new one called `Refresh Screen`
- Use `/usr/bin/lenovod330-10igl-refreshscreen.sh`
- Add a shortcut like `Ctrl+Shift+R`
3. Make xorg config dir:
```
sudo mkdir -v /etc/X11/xorg.conf.d
```
4. Create Xorg files:
```
echo -e 'Section "ServerFlags"\n Option "BlankTime" "0"\n Option "StandbyTime" "0"\n Option "SuspendTime" "0"\n Option "OffTime" "0"\n Option "dpms" "false"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/10-xorg.conf
echo -e 'Section "Device"\n Identifier "Intel Graphics"\n Driver "Intel"\n Option "DRI" "3"\n Option "AccelMethod" "sna"\n Option "TearFree" "true"\n Option "VSync" "false"\n Option "TripleBuffer" "false"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf
echo -e 'Section "Monitor"\n Identifier "DSI-1"\n Option "Rotate" "right" \nEndSection' | sudo tee /etc/X11/xorg.conf.d/30-monitor.conf
echo -e '# IdeaPad D330-10IGM (both 81H3 and 81MD product names)\nsensor:modalias:acpi:BOSC0200*:dmi:*:svnLENOVO:*:pvrLenovoideapadD330-10IGM:*\n ACCEL_MOUNT_MATRIX=0, 1, 0; -1, 0, 0; 0, 0, 1\n\n# IdeaPad D330-10IGL(82H0)\nsensor:modalias:acpi:BOSC0200*:dmi:*:svnLENOVO:*:pvrLenovoideapadD330-10IGL:*\n ACCEL_MOUNT_MATRIX=0, 1, 0; -1, 0, 0; 0, 0, 1' | sudo tee /etc/udev/hwdb.d/61-sensor-local.hwdb
```
5. Rotate screen:
```
xrandr -o right
```
6. Reset sensors
```
sudo systemd-hwdb update
sudo udevadm trigger -v -p DEVNAME=/dev/iio:device0
sudo service iio-sensor-proxy restart
```
7. Reboot


## Black Screen fix
- Notebook mode: Press Ctrl+Shift+R until working screen.
- Tablet mode: Rotate device until working screen.


## Hibernate & suspend
Disable hibernate and suspend options, it may cause blank screen.
1. Open Power Managment and disable all hibernate and suspend options to "never" or "do nothing".
2. Open Screensaver and disable suspend option.


## Battery
1. Download and install auto-cpufreq:
```
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
```
2. Choose Option "i"
3. Run daemon:
```
sudo auto-cpufreq --install
```


## Webcam
For setting front camera as default, add these files:
```
sudo wget -O /etc/systemd/system/lenovod330-10igl-webcam.service https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-webcam.service
sudo wget -O /usr/bin/lenovod330-10igl-webcam.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-webcam.sh
sudo chmod +x /etc/systemd/system/lenovod330-10igl-webcam.service
sudo chmod +x /usr/bin/lenovod330-10igl-webcam.sh
sudo systemctl enable lenovod330-10igl-webcam.service
sudo systemctl start lenovod330-10igl-webcam.service
```


## Multitouch
1. Install [Touchegg](https://github.com/JoseExposito/touchegg/releases/latest).
2. Firefox touchscreen fix
```
echo export MOZ_USE_XINPUT2=1 | sudo tee /etc/profile.d/use-xinput2.sh
```
4. Reboot

## Touchpad

Open Keyboard Settings > Shortcuts > System > Hardware
* Find `Toggle Touchpad state`
* Add this shortcut `Fn+Supr` (Ctrl+Supr0xca)

 
## Credits:
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
