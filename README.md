# Linux Mint in Lenovo D330
Install Linux Mint in Lenovo D330

## Issues
- Non standar BIOS ACPI: boot error messages.
- Non standar monitor resolution (800x1280): black screen and portrait as default.
- No Legacy BIOS: flickering screen in recovery mode (nomodeset) and other video issues.

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

## Kernel
1. Go to [Ubuntu Kernel PPA Mainline](https://kernel.ubuntu.com/~kernel-ppa/mainline/)
2. Get into the last v4.19.x folder from the first group of links, download:
- linux-headers-4.19.x-generic_4.19.x_amd64.deb
- linux-image-unsig-4.19.x-generic_4.19.x_amd64.deb
- linux-modules-4.19.x-generic_4.19.x_amd64.deb
- linux-headers-4.19.x_5.4.x_all.deb
4. In the same folder you download, open terminal and type:
```
sudo dpkg -i linux*.deb
```
5. Reboot (if black screen reboot again).
6. Install Grub Customizer with [mintinstall](https://github.com/linuxmint/mintinstall) and move 4.19.x kernel at first option.
7. Remove all other kernels with [mintupdate](https://github.com/linuxmint/mintupdate).
8. [Mintupdate](https://github.com/linuxmint/mintupdate) will ask for upadte to a highter kernel. Right click and set something like "ignore all future update of this packages"

## Landscape mode
Only for notebook mode, if you want to stay in tablet mode, you can disable this method from startup.<br>
1. Download and add this [landscape script](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/landscape.sh) to startup<br>
2. Go to the file, open terminal and type `sudo chmod +x landscape.sh` to change permissions.
3. Reboot.

## Auto rotate
Only for tablet mode, if you want to stay in notebook mode, you can disable this method from startup.<br>
1. Install Inotify tools, open terminal and type:
```
sudo apt-get install inotify-tools -y
```
2. Download and add this [auto-rotate script](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/auto_rotate.sh) to startup<br>
3. Go to the file, open terminal and type `sudo chmod +x auto_rotate.sh` to change permissions.
4. Reboot.

## Black Screen
### Tablet mode:
- Rotate device until black screen dissapear.
### Notebook mode:
- Open Keyboard Settings > Shortcuts > Custom Shortcuts.
- Add new one called Landscape Refresh.
- Use [landscape script](https://github.com/lucasgabmoreno/linuxmint_lenovod330/blob/main/landscape.sh) (With execution permission enabled).
- Add a shortcut like Ctrl+Shift+L.
- When black screen, press Ctrl+Shift+L until black screen dissapear.

## Firmware
1. Dowload [adlp_dmc_ver2_14.bin](https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/adlp_dmc_ver2_14.bin)
2. Move bin file into `/lib/firmware/i915`
3. Terminal ```sudo update-initramfs -u```

## Hwmatch & Boot
1. Install Grub Customizer with [mintinstall](https://github.com/linuxmint/mintinstall)
2. General settings > Kernel parameters: 
```
quiet splash acpi_osi=Linux acpi=force gfxpayload=800x600 fbcon=rotate:0 i915.modeset=1 nvidia.modeset=0 nouveau.modeset=0 radeon.modeset=0 r128.modeset=0 
```
4. General settings > Advanced settings > Add: 
```
GRUB_GFXPAYLOAD_LINUX=keep
```

## Multitouch
1. Install Touchegg with [mintinstall](https://github.com/linuxmint/mintinstall)
2. Reboot

## Xserver Xorg 
1. Debloat drivers:
```
sudo apt-get remove xserver-xorg-video-* -y
sudo apt-get remove --auto-remove xserver-xorg-video-* -y
sudo apt-get purge xserver-xorg-video-* -y
sudo apt-get purge --auto-remove xserver-xorg-video-* -y
```
2. Install only Intel:
```
sudo apt-get install xserver-xorg-video-intel -y
```

## Bugs still can't fix
1. [Issue #5](https://github.com/lucasgabmoreno/linuxmint_lenovod330/issues/5): Randomly, when starting PC, doesn't show grub, splash and first screen. All in black screen. <br>
Temporary solution: [use this method](https://github.com/lucasgabmoreno/linuxmint_lenovod330#temporary-fix-autorotate--landscape-mode-black-screen)
2. [Issue #6](https://github.com/lucasgabmoreno/linuxmint_lenovod330/issues/6): Randomly, when rotate, shows black screen. <br>
Temporary solution: [use this method](https://github.com/lucasgabmoreno/linuxmint_lenovod330#temporary-fix-autorotate--landscape-mode-black-screen)
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
- [Angelo](https://unixcop.com/fix-the-error-cant-find-the-command-hwmatch-on-grub/)
