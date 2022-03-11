# Linux Mint in Lenovo D330
Install Linux Mint in Lenovo D330

## Device
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

## Make Windows Backup
Enchufar el USB
Bootear el USB: Fn+F12

Si aparecela pantalla negra, forzar desde el grub "ckeck the integrity medium" o con la entrada "compatibility mode"

Vamos a tener que trabajar todo el tiempo con la pantalla girada

Desde el instalador, montar un disco externo (disk, buscar la unidad y darle play) y hacer un backup de la unidad de Windows de 64 GB, tal como vino de fábrica
sudo dd if=/dev/mmcblk0 of="/media/mint/Backups/Win10-d330-update.img" bs=4096 status=progress conv=sync,noerror

Si necesitamos restaurar Windows mas adelante, simplemente:
sudo dd if="/media/mint/Backups/Win10-d330.img" of=/dev/mmcblk0 bs=4096 status=progress conv=sync,noerror

---

WINDOWS BACKUP




---

MBR A GPT

Desde el instalador de Linux Mint

Abrir gparted

Con gparted seleccionar y desmontar la sdcard
Device
Create partition table
gpt
Crear una partición ext4
Edit 
Apply allá operations

----

/EFI boot partition 550 MB logica
/boot 1gb primaria 1024 MB
/ 16gb logica 16384 MB
/usr 27gb logica 27648 MB
/var logica resto del espacio
/swap 4gb 4096 MB

Sdcard
/home resto logica

----

Cuando termine de instalar y reinicie, si la pantalla es negra, reiniciar desmontando el teclado y se acomoda

Actualizar Linux Mint


