# Linux Mint in Lenovo IdeaPad D330-10IGL 82H0
This guide is to install Linux Mint in Lenovo IdeaPad D330-10IGL 82H0 as less buggy as possible. This guide won't work in Lenovo IdeaPad D330-10IGM 81H3 (FHD version), but maybe could work in Lenovo IdeaPad D330-10IGM 81MD.<br>
Don't install Linux Mint Ubuntu Edition, it will cause blank screen in grub and flickering screen in recovery mode and nomodeset. Install [LMDE Linux Mint Debian Edition](https://www.linuxmint.com/download_lmde.php) instead.


## Issues
- No standar BIOS ACPI.
- No standar monitor resolution for 800x1280 devices.
- No Legacy BIOS support.


## Device
| &nbsp; | 81MD | 82H0 |
| :--- | :--- | :--- |
| Model | Lenovo IdeaPad D330-10IGM | Lenovo IdeaPad D330-10IGL |
| Proccesor | Celeron | Celeron |
| Graphics | UHD Graphics 600 | UHD Graphics 605 |
| Resolution | 800x1280 | 800x1280 |
| Quality | HD | HD |
| Storage | 64 | 64 |
| RAM | 4 | 4 |

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
You will notice your screen in portrait orientation. Don't force rotate in Display options yet, it will make black screen (will fix when [installing kernel](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/README.md#kernel)).
3. [Make a Windows Backup](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/WINDOWS.md#windows-backup).
4. [Update BIOS and Firmware](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/WINDOWS.md#update-bios-and-firmware).
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
Otherwise, let Linux Mint installer automatically manage partitions on internal storage.
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
sudo apt install grub-customizer inotify-tools iio-sensor-proxy mesa-utils git -y
```


## Grub
1. Open Grub Customizer
2. General settings > Kernel parameters: <br>
```
quiet splash nomodeset gfxpayload=800x1280
```
3. General settings > Advanced settings > Add: 
```
GRUB_GFXPAYLOAD_LINUX=keep
```


## Kernel
1. Go to [Ubuntu Kernel PPA Mainline](https://kernel.ubuntu.com/~kernel-ppa/mainline/).
2. Get into the last v4.19.x folder and download:
- linux-headers-4.19.x-generic_4.19.x_amd64.deb
- linux-image-unsig-4.19.x-generic_4.19.x_amd64.deb
- linux-modules-4.19.x-generic_4.19.x_amd64.deb
- linux-headers-4.19.x_4.19.x_all.deb
3. In the same folder you download, open terminal and type:
```
sudo dpkg -i linux*.deb
```
4. Open Grub Customizer and move 4.19.x kernel at first option.
5. Mintupdate will ask for upadte to a highter kernel. Right click and set something like "ignore all future update of this packages"

*Last 4.19.x is not an older kernel, it's an up to date long term release kernel.*<br>
*At your own risk, if you have the knowledge, you could build your own kernel with [this patches](KERNELPATCH.md).*


## Display
1. Add files:
```
sudo wget -O /usr/bin/lenovod330-10igl-display.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-display.sh
sudo wget -O /usr/bin/lenovod330-10igl-refreshscreen.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-refreshscreen.sh
sudo chmod +x /usr/bin/lenovod330-10igl-display.sh
sudo chmod +x /usr/bin/lenovod330-10igl-refreshscreen.sh
```
2. Add `/usr/bin/lenovod330-10igl-display.sh` to startup
3. Open Keyboard Settings > Shortcuts > Custom Shortcuts
- Add new one called `Refresh Screen`
- Use `/usr/bin/lenovod330-10igl-refreshscreen.sh`
- Add a shortcut like `Ctrl+Shift+R`
4. Make xorg config dir:
```
sudo mkdir -v /etc/X11/xorg.conf.d
```
5. Create Xorg files:
```
echo -e 'Section "ServerFlags"\n Option "BlankTime" "0"\n Option "StandbyTime" "0"\n Option "SuspendTime" "0"\n Option "OffTime" "0"\n Option "dpms" "false"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/10-xorg.conf
echo -e 'Section "Device"\n Identifier "Intel Graphics"\n Driver "Intel"\n Option "DRI" "3"\n Option "AccelMethod" "sna"\n Option "TearFree" "true"\n Option "VSync" "false"\n Option "TripleBuffer" "false"\nEndSection' | sudo tee /etc/X11/xorg.conf.d/20-intel.conf
echo -e 'Section "Monitor"\n Identifier "DSI-1"\n Option "Rotate" "right" \nEndSection' | sudo tee /etc/X11/xorg.conf.d/30-monitor.conf
```
6. Reboot.
7. Open display app and choose counter-clock wise and apply.


## Black Screen fix
- Tablet mode: Rotate device until working screen.
- Notebook mode: Press Ctrl+Shift+R until working screen.


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

 
## Thanks:
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
