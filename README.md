# Linux Mint in Lenovo D330
Install Linux Mint in Lenovo D330

## Device

| Name | Specification |
| :--- | :--- |
| Model | Lenovo IdeaPad D330-10IGL |
| Proccesor | Intel Celeron N4020 |
| Graphics | Intel UHD Graphics 605 |
| Resolution | 800x1280 |
| Storage | 64Gb EMMC |
| RAM | 4Gb |
| Micro SD CArd | 128 GB U3 |

[*Complete device specifications...*](completedevicespecifications.md)

---

## (Optional) Update Windows, BIOS and Firmware
1. Boot Windows.
2. [Download and install Lenovo Service Bridge](https://support.lenovo.com/solutions/ht104055).
3. [Disable S Windows Mode](https://support.microsoft.com/en-us/windows/switching-out-of-s-mode-in-windows-4f56d9be-99ec-6983-119f-031bfb28a307).
4. [Run Windows Update](https://support.microsoft.com/en-us/windows/update-windows-3c5ae7fc-9fb6-9af1-1984-b5e0412c556a#WindowsVersion=Windows_10).
5. [Open Lenovo Vantage](https://www.microsoft.com/p/lenovo-vantage/9wzdncrfj4mv?rtc=1&activetab=pivot:overviewtab) and update drivers and system.
7. Detect your device with [Lenovo Support](https://support.lenovo.com/solutions/ht104055), download and install BIOS and EMMC Firmware update.

## How to acces BIOS
1. Turn off device (10 seconds power button)
2. Turn on device (5 seconds power button)
3. Inmediattely press:
`Fn+F2`

## How to access Boot Options
1. Turn off device (10 seconds power button)
2. Turn on device (5 seconds power button)
3. Inmediattely press:
`Fn+F12`

## Disable secure boot
1. Access BIOS
2. Disable Secure Boot

## How to Boot Linux Mint Installer
1. Access boot options
2. Choose USB device

If black screen, you can try:
* Reboot again
* "ckeck the integrity medium"
* "compatibility mode"

If Screen in portrait orientation:
* Don't force rotate in Display options yet, it will make black screen (will fix later).

## (Optional) Make a Windows Backup
1. Boot Linux Mint Installer
2. Mount external USB storage 
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
1. Boot Linux Installer
2. Open gparted
3. Choose micro sd card device
4. Unmount it
5. Remove micro sd card partitions
6. Device > Create partition table > gpt
7. Create an ext4 partition
8. Edit > Apply all operations

## Install Linux Mint
1. Boot Linux Mint
2. Open Installer
3. If you have micro SD, I recommend this partition map:
```
Internal storage:
/EFI boot partition 550 MB logic
/boot 1024 MB primary
/ (root) 16384 MB logic
/usr 27648 MB logic
/var (use all free space) logic
/swap 4096 MB

Micro sd card:
/home (use all free space) logic
```

## Boot Linux Mint
Once installed, reboot.<br>
If black screen, you can try:
* Reboot again
* Unmount keyboard and rotate device
* Boot from USB installer and reboot again.

## Update Linux Mint
Open [mintupdate](https://github.com/linuxmint/mintupdate) and update all software

## Fix some black screen (not all)
If your kernel is lower than 5.4.152, you must upgrade your kernel to the latest 5.4.x.<br>
Don't upgrade to 5.5, 5.13, etc. wont' work. Stay in 5.4<br>

1. Go to [Ubuntu Kernel PPA Mainline](https://kernel.ubuntu.com/~kernel-ppa/mainline/)
2. Get into the last v5.4.x folder
3. From the first group of links, download:
- linux-headers-5.4.x-generic_5.4.x_amd64.deb
- linux-image-unsigned-5.4.x-generic_5.4.x_amd64.deb
- linux-modules-5.4.x-generic_5.4.x_amd64.deb
- linux-headers-5.4.x_5.4.x_all.deb
4. In the same folder you download, open terminal and type:
```
sudo dpkg -i linux*.deb
```
5. Reboot (If black screen reboot again).
6. Mint update wil ask for upadte to a highter kernel like 5.13, etc. Right click and set something like "ignore all future update of this packages"

## Fix to start in landscape mode
Only for notebook mode, if you want to stay in tablet mode, you can disable this method from startup.
1.Download and add this [landscape script](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/landscape.sh) to startup<br>
2. Go to the file, open terminal and type `sudo chmod +x landscape.sh` to change permissions.
3. Reboot.

## Fix auto rotate
Only for tablet mode, if you want to stay in notebook mode, you can disable this method from startup.
1. Install IIO sensor proxy and Inotify tools, open terminal and type:
```
apt-get install iio-sensor-proxy inotify-tools
```
2. Download and add this [auto-rotate script](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/auto_rotate.sh) to startup<br>
3. Go to the file, open terminal and type `sudo chmod +x auto_rotate.sh` to change permissions.
4. Reboot.


## Fix brightness change on every boot and rotation
1. Move brightness to 100%
2. Install [Brightness and Gamma Applet](https://cinnamon-spices.linuxmint.com/applets/view/286)
3. Use this applet instead of default brightness method

## Temporary fix autorotate & landscape mode black screen
Tablet mode:
- Rotate device until black screen dissapear.
Notebook mode:
- Open Keyboard Settings > Shortcuts > Custom Shortcuts.
- Add new one called Landscape Refresh.
- Use [landscape script](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/landscape.sh) (With execution permission enabled).
- Add a shortcut like Ctrl+Shift+L.
- When black screen, press this shortcut until black screen dissapear.

## Bugs still can't fix
1. [Issue #5](https://github.com/lucasgabmoreno/linuxmint_lenovod330/issues/5): Randomly, when starting PC, doesn't show grub, splash and first screen. All in black screen. <br>
Temporary solution: rotate device until screen shows image.
2. [Issue #6](https://github.com/lucasgabmoreno/linuxmint_lenovod330/issues/6): Randomly, when rotate, shows black screen. <br>
Temporary solution: rotate device again until screen shows image.
3. [Issue #7](https://github.com/lucasgabmoreno/linuxmint_lenovod330/issues/7): Video tearing. <br>
No solution temporary
4. [Issue #8](https://github.com/lucasgabmoreno/linuxmint_lenovod330/issues/8): Can't get into safe mode
 
## Thanks:
- [Lenovo Support](https://support.lenovo.com)
- [Lenovo Forums](https://forums.lenovo.com/t5/Ubuntu/Linux-on-Ideapad-D330/m-p/4296738)
- [Microsoft Support](https://support.microsoft.com)
- [Linux Mint Forum](https://forums.linuxmint.com)
- [Ubuntu Kernel PPA](https://kernel.ubuntu.com/~kernel-ppa/mainline/)
- [Karla's Project](https://youtu.be/vFA-phErf9o)
- [Rojtberg](https://www.rojtberg.net/1652/ubuntu-on-the-lenovo-d330/)
- [Markus](https://gist.github.com/Links2004/5976ce97a14dabf773c3ff98d03c0f61)
