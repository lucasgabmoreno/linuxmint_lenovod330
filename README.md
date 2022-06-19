# Linux Mint in Lenovo IdeaPad D330-10IGL 82H0
This is a guide to install Linux Mint in Lenovo IdeaPad D330-10IGL 82H0 as less buggy as possible. This guide won't work in Lenovo IdeaPad D330-10IGM 81H3 (FHD version), but maybe could work in Lenovo IdeaPad D330-10IGM 81MD.<br>
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

## (Optional) Update BIOS and Firmware
1. Boot Windows.
2. [Download and install Lenovo Service Bridge](https://support.lenovo.com/solutions/ht104055).
3. [Disable S Windows Mode](https://support.microsoft.com/en-us/windows/switching-out-of-s-mode-in-windows-4f56d9be-99ec-6983-119f-031bfb28a307).
4. Download and install [BIOS Firmware Upgrade](https://support.lenovo.com/us/en/downloads/ds545459-bios-update-for-windows-10-64-bit-d330-10igl)
5. Download and install [EMMC Firmware Upgrade](https://pcsupport.lenovo.com/ar/es/downloads/ds553169-wd-7550-emmc-firmware-update-to-qs14d-winbook)<br>

*At your own risk, if you have the knowledge, you could dissamble the Lenovo BIOS Firmware with [this method](https://github.com/liho98/lenovo-bios-logo-extraction-guide#dependencies) and [this method](https://patrikesn.wordpress.com/2015/01/11/guide-unlocking-the-hidden-bios-pages-on-lenovo-miix-2-11/), and make a better ACPI, Legacy mode enable, etc.*

## BIOS
1. Turn off device (10 seconds power button)
2. Turn on device (5 seconds power button)
3. Inmediattely press:
`Fn+F2`

## Boot Options
1. Turn off device (10 seconds power button)
2. Turn on device (5 seconds power button)
3. Inmediattely press:
`Fn+F12`

## Disable secure boot
1. [Access BIOS](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/README.md#bios)
2. Disable Secure Boot

## Boot Linux Mint Installer
1. [Access boot options](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/README.md#boot-options)
2. Choose USB device

If black screen, you can try:
* Reboot again
* "ckeck the integrity medium"
* "compatibility mode"

If Screen in portrait orientation:
* Don't force rotate in Display options yet, it will make black screen (will fix later).

## (Optional) Make a Windows Backup
1. Boot Linux Mint Installer
2. Mount an external USB storage 
3. Open terminal and make a backup<br>
```
sudo dd if=[path to 64GB Windows Storage] of="[path to external USB storage]/[filename.img]" bs=4096 status=progress conv=sync,noerror
```
*Example: sudo dd if=/dev/mmcblk0 of="/media/mint/MyExternalStorage/Win10-d330.img" bs=4096 status=progress conv=sync,noerror*

4. If you need to restore Windows<br>
```
sudo dd if="[path to external USB storage]/[filename.img]" of=[path to 64GB Windows Storage] bs=4096 status=progress conv=sync,noerror
```

## Convert micro SD card to GPT System Partition
1. [Boot Linux Mint Installer](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/README.md#boot-linux-mint-installer)
2. Open gparted
3. Choose micro sd card device
4. Unmount it
5. Remove micro sd card partitions
6. Device > Create partition table > gpt
7. Create an ext4 partition
8. Edit > Apply all operations

## Install Linux Mint
1. [Boot Linux Mint Installer](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/README.md#boot-linux-mint-installer)
2. Open Installer
3. If you have micro SD, I recommend this partition map:<br>
```
Internal storage:
/EFI boot partition 1024 MB logic  (Flags: boot, esp)
/ (root) (use all free space) logic
/swap 2048 MB

Micro sd card:
/home (use all free space) logic
```

## Boot Linux Mint
Once installed, reboot.<br>
When Grub, choose "recovery mode".<br>
If black screen, you can try:
* Reboot again
* Boot from USB installer and reboot again.

## Grub
1. Install Grub Customizer with [mintinstall](https://github.com/linuxmint/mintinstall)
2. General settings > Kernel parameters: <br>
```
quiet splash nomodeset gfxpayload=800x1280
```
4. General settings > Advanced settings > Add: 
```
GRUB_GFXPAYLOAD_LINUX=keep
```

## Kernel
1. Go to [Ubuntu Kernel PPA Mainline](https://kernel.ubuntu.com/~kernel-ppa/mainline/)
2. Get into the last v4.19.x folder from the first group of links, download:
- linux-headers-4.19.x-generic_4.19.x_amd64.deb
- linux-image-unsig-4.19.x-generic_4.19.x_amd64.deb
- linux-modules-4.19.x-generic_4.19.x_amd64.deb
- linux-headers-4.19.x_4.19.x_all.deb
3. In the same folder you download, open terminal and type:
```
sudo dpkg -i linux*.deb
```
4. Reboot (if black screen reboot again).
5. Open Grub Customizer and move 4.19.x kernel at first option.
6. Mintupdate will ask for upadte to a highter kernel. Right click and set something like "ignore all future update of this packages"

*At your own risk, if you have the knowledge, you could build your own kernel with [this patches](KERNELPATCH.md).*

## Landscape orientation & rotation
1. Install dependencies
```
sudo apt-get install inotify-tools iio-sensor-proxy -y
```
2. Copy and paste on terminal
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
3. Reboot.

## Hibernate & suspend
Disable hibernate and suspend options, it may cause blank screen.
1. Open Power Managment and disable all hibernate and suspend options to "never" or "do nothing".
2. Open Screensaver and disable suspend option.

## Webcam front camera default
Copy and paste on terminal
```
sudo wget -O /etc/systemd/system/lenovod330-10igl-webcam.service https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-webcam.service
sudo wget -O /usr/bin/lenovod330-10igl-webcam.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-webcam.sh
sudo chmod +x /etc/systemd/system/lenovod330-10igl-webcam.service
sudo chmod +x /usr/bin/lenovod330-10igl-webcam.sh
sudo systemctl enable lenovod330-10igl-webcam.service
sudo systemctl start lenovod330-10igl-webcam.service
```

## Black Screen
- Tablet mode: Rotate device until black screen dissapear.
- Netebook mode: Press Ctrl+Shift+R until black screen dissapear.

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
