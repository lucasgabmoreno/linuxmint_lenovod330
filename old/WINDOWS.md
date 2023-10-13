## Windows Backup
This device has his own Microsoft Office and modified Lenovo's Windows licenced version. It's recommended to make backup before install other OS.
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

## Update BIOS and Firmware
1. Boot Windows.
2. [Download and install Lenovo Service Bridge](https://support.lenovo.com/solutions/ht104055).
3. [Disable S Windows Mode](https://support.microsoft.com/en-us/windows/switching-out-of-s-mode-in-windows-4f56d9be-99ec-6983-119f-031bfb28a307).
4. Download and install [BIOS Firmware Upgrade](https://support.lenovo.com/us/en/downloads/ds545459-bios-update-for-windows-10-64-bit-d330-10igl)
5. Download and install [EMMC Firmware Upgrade](https://pcsupport.lenovo.com/ar/es/downloads/ds553169-wd-7550-emmc-firmware-update-to-qs14d-winbook)<br>

*At your own risk, if you have the knowledge, you could dissamble the Lenovo BIOS Firmware with [this method](https://github.com/liho98/lenovo-bios-logo-extraction-guide#dependencies) and [this method](https://patrikesn.wordpress.com/2015/01/11/guide-unlocking-the-hidden-bios-pages-on-lenovo-miix-2-11/), and make a better ACPI, Legacy mode enable, etc.*
