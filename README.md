# Linux Mint in Lenovo D330
This is a guide to install Linux Mint in Lenovo D330-10IGL as less buggy as possible.

## Issues
- No standar BIOS ACPI.
- No DP (Display Port), DSI (Display Serial Interface) instead.
- No standar monitor resolution: 800x1280.
- No Legacy BIOS support.
- Newer kernels does not apply [this patch](https://patchwork.freedesktop.org/patch/317041/)


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

## (Optional) Update BIOS and Firmware
1. Boot Windows.
2. [Download and install Lenovo Service Bridge](https://support.lenovo.com/solutions/ht104055).
3. [Disable S Windows Mode](https://support.microsoft.com/en-us/windows/switching-out-of-s-mode-in-windows-4f56d9be-99ec-6983-119f-031bfb28a307).
4. Download and install [BIOS Firmware Upgrade](https://support.lenovo.com/us/en/downloads/ds545459-bios-update-for-windows-10-64-bit-d330-10igl)
5. Download and install [EMMC Firmware Upgrade](https://pcsupport.lenovo.com/ar/es/downloads/ds553169-wd-7550-emmc-firmware-update-to-qs14d-winbook)<br>

*At your own risk, if you have the knowledge, you could dissamble the Lenovo BIOS Firmware with [this method](https://github.com/liho98/lenovo-bios-logo-extraction-guide#dependencies) and [this method](https://patrikesn.wordpress.com/2015/01/11/guide-unlocking-the-hidden-bios-pages-on-lenovo-miix-2-11/), and correct ACPI, Legacy mode enable, etc.*

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
/swap 2048 MB

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

## Grub
1. Install Grub Customizer with [mintinstall](https://github.com/linuxmint/mintinstall)
2. General settings > Kernel parameters: 
```
quiet splash acpi_osi=Linux acpi=force gfxpayload=800x1280 fbcon=rotate:0 i915.modeset=1 i915.runpm=1 loglevel=0  i915.enable_dc=0 i915.enable_fbc=0 i915.enable_psr=0 i915.enable_guc=0 i915.enable_dpcd_backlight=0 i915.disable_power_well=1 i915.reset=1 i915.mitigations=auto i915.fastboot=0
```
4. General settings > Advanced settings > Add: 
```
GRUB_GFXPAYLOAD_LINUX=keep
```

## Firmware
1. Dowload [adlp_dmc_ver2_14.bin](https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/i915/adlp_dmc_ver2_14.bin)
2. Move bin file into `/lib/firmware/i915`
3. Terminal ```sudo update-initramfs -u```

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
5. Install Grub Customizer with [mintinstall](https://github.com/linuxmint/mintinstall) and move 4.19.x kernel at first option.
6. Remove all other kernels with [mintupdate](https://github.com/linuxmint/mintupdate).
7. Mintupdate will ask for upadte to a highter kernel. Right click and set something like "ignore all future update of this packages"

## Front webcam default & Landscape orientation default & Refresh screen shortcut
1. Install dependencies
```
sudo apt-get install inotify-tools -y
```
2. Copy and paste in terminal
```
sudo wget -O /etc/systemd/system/lenovod330-10igl-webcam.service https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-webcam.service
sudo wget -O /usr/bin/lenovod330-10igl-webcam.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-webcam.sh
sudo wget -O /usr/bin/lenovod330-10igl-display.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-display.sh
sudo wget -O /usr/bin/lenovod330-10igl-refreshscreen.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-10igl-refreshscreen.sh
sudo chmod +x /etc/systemd/system/lenovod330-10igl-webcam.service
sudo chmod +x /usr/bin/lenovod330-10igl-webcam.sh
sudo chmod +x /usr/bin/lenovod330-10igl-display.sh
sudo chmod +x /usr/bin/lenovod330-10igl-refreshscreen.sh
sudo systemctl enable lenovod330-10igl-webcam.service
sudo systemctl start lenovod330-10igl-webcam.service
```
2. Add `/usr/bin/lenovod330-10igl-display.sh` to startup
3. Open Keyboard Settings > Shortcuts > Custom Shortcuts.
- Add new one called Refresh Screen.
- Use `/usr/bin/lenovod330-10igl-refreshscreen.sh`
- Add a shortcut like Ctrl+Shift+R.
3. Reboot.

## Black Screen
### Tablet mode:
- Rotate device until black screen dissapear.
### Notebook mode:
- Press Ctrl+Shift+L until black screen dissapear.

## Multitouch
1. Install [Touchegg](https://github.com/JoseExposito/touchegg) with [mintinstall](https://github.com/linuxmint/mintinstall)
2. Firefox touchscreen fix:
```
echo export MOZ_USE_XINPUT2=1 | sudo tee /etc/profile.d/use-xinput2.sh
```
4. Reboot

## Bugs still can't fix
1. [Issue #6](https://github.com/lucasgabmoreno/linuxmint_lenovod330/issues/6): Randomly, when rotate, shows black screen. <br>
Temporary solution: [use this method](https://github.com/lucasgabmoreno/linuxmint_lenovod330#temporary-fix-autorotate--landscape-mode-black-screen)
2. [Issue #7](https://github.com/lucasgabmoreno/linuxmint_lenovod330/issues/7): Video tearing. <br>
No solution temporary
3. [Issue #8](https://github.com/lucasgabmoreno/linuxmint_lenovod330/issues/8): Can't get into safe mode
 
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
