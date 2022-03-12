# Linux Mint in Lenovo D330
Install Linux Mint in Lenovo D330

## Device

| Name | Specification |
| :--- | :--- |
| Model | Lenovo IdeaPad D330-10IGL |
| Proccesor | Intel Celeron N4020 |
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

## Disable secure boot
1. Go to BIOS <br>
`Power Button > Fn+F2`
2. Disable Secure Boot

## Boot Linux Mint Installer
1. Plug Linux Mint USB Installer
2. Boot USB 
`Power Button > Fn+F12`
3. Choose USB device

| Problem | Solution |
| :--- | :----------- |
| Black screen | Turn off and boot again with grub options like "ckeck the integrity medium" or "compatibility mode" and boot normal mode again. If same problem in installed Linux Mint, boot with USB installer and reboot again. Will fix it later |
| Screen in portrait orientation | Don't force rotate in Display options, it will make black screen. Will fix later. |

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
3. Create partitions:
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

## Upgrade Kernel
Don't upgrade to a newer kernel version than 5.4.155, maybe won't work.<br>
If you have tried a newer version and you don't have black screen problem when rotation, let's us know in [this issue](https://github.com/lucasgabmoreno/linuxmint_lenovod330/issues/1).<br>
Open terminal
```
sudo rm -rf linux*.deb
sudo wget -t inf "https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.155/amd64/linux-headers-5.4.155-0504155-generic_5.4.155-0504155.202110200637_amd64.deb"
sudo wget -t inf "https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.155/amd64/linux-image-unsigned-5.4.155-0504155-generic_5.4.155-0504155.202110200637_amd64.deb"
sudo wget -t inf "https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.155/amd64/linux-modules-5.4.155-0504155-generic_5.4.155-0504155.202110200637_amd64.deb"
sudo wget -t inf "https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.4.155/amd64/linux-headers-5.4.155-0504155_5.4.155-0504155.202110200637_all.deb"
sudo dpgk -i linux*.deb
sudo rm -rf linux*.deb
```
Reboot

## Temporary rotation fix
Open terminal
```
xrandr -o right

```

## Thanks:
- [Lenovo Support](https://support.lenovo.com)
- [Lenovo Forums](https://forums.lenovo.com/t5/Ubuntu/Linux-on-Ideapad-D330/m-p/4296738)
- [Microsoft Support](https://support.microsoft.com)
- [Linux Mint Forum](https://forums.linuxmint.com)
- [Ubuntu Kernel PPA](https://kernel.ubuntu.com/~kernel-ppa/mainline/)
- [Karla's Project](https://youtu.be/vFA-phErf9o)
- [Rojtberg](https://www.rojtberg.net/1652/ubuntu-on-the-lenovo-d330/)
