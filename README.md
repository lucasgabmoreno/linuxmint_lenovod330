# Linux Mint in Lenovo D330
Install Linux Mint in Lenovo D330

## Device

| Name | Solution |
| :--- | :----------- |
| Black screen | Turn off and boot again with grub options like "ckeck the integrity medium" or "compatibility mode" and boot normal mode again. It's an old kernel problem. Will fix it later |
| Screen in portrait orientation | Don't force rotate in Display options, it will make black screen. Will fix when installed and kernel update. |

* Model: Lenovo IdeaPad D330-10IGL
* Proccesor: Intel Celeron N4020
* Storage: 64Gb EMMC 5.1
* RAM: 4Gb LP4 2133
* Micro SD Card: 128 GB U3
* [*Complete device specifications...*](completedevicespecifications.md)

---

## Update Windows, BIOS and Firmware
1. Boot Windows.
2. [Download and install Lenovo Service Bridge](https://support.lenovo.com/solutions/ht104055).
3. [Disable S Windows Mode](https://support.microsoft.com/en-us/windows/switching-out-of-s-mode-in-windows-4f56d9be-99ec-6983-119f-031bfb28a307).
4. [Run Windows Update](https://support.microsoft.com/en-us/windows/update-windows-3c5ae7fc-9fb6-9af1-1984-b5e0412c556a#WindowsVersion=Windows_10).
5. [Open Lenovo Vantage](https://www.microsoft.com/p/lenovo-vantage/9wzdncrfj4mv?rtc=1&activetab=pivot:overviewtab) and update drivers and system.
7. Detect your device with [Lenovo Support](https://support.lenovo.com/solutions/ht104055), download and install BIOS and EMMC Firmware update.

## Config your BIOS
1. Go to BIOS <br>
`Power Button > Fn+F2`
2. Disable Secure Boot

## Boot Linux Mint Installer
1. Plug Linux Mint USB Installer
2. Boot USB 
`Power Button > Fn+F12`
3. Choose USB Boot

| Problem | Solution |
| :--- | :----------- |
| Black screen | Turn off and boot again with grub options like "ckeck the integrity medium" or "compatibility mode" and boot normal mode again. It's an old kernel problem. Will fix it later |
| Screen in portrait orientation | Don't force rotate in Display options, it will make black screen. Will fix when installed and kernel update. |

## Make Windows Backup
1. Boot Linux Mint Installer
2. Mount external USB storage 
3. Open terminal and make a backup<br>
`sudo dd if=[path to 64GB Windows Storage] of="[path to external USB storage]/[filename.img]" bs=4096 status=progress conv=sync,noerror` <br>
> *Example: sudo dd if=/dev/mmcblk0 of="/media/mint/MyExternalStorage/Win10-d330.img" bs=4096 status=progress conv=sync,noerror*
4. If you need to restore Windows<br>
`sudo dd if="[path to external USB storage]/[filename.img]" of=[path to 64GB Windows Storage] bs=4096 status=progress conv=sync,noerror` <br>

## Convert micro SD to GPT System Partition
Desde el instalador de Linux Mint

Abrir gparted

Con gparted seleccionar y desmontar la sdcard
Device
Create partition table
gpt
Crear una partición ext4
Edit 
Apply allá operations


## Install Linux Mint
Internal Storage
/EFI boot partition 550 MB logica
/boot 1gb primaria 1024 MB
/ 16gb logica 16384 MB
/usr 27gb logica 27648 MB
/var logica resto del espacio
/swap 4gb 4096 MB
Sdcard
/home resto logica

## Boot Linux Mint
Cuando termine de instalar y reinicie, si la pantalla es negra, reiniciar desmontando el teclado y se acomoda

## Update Linux Mint
Actualizar Linux Mint


