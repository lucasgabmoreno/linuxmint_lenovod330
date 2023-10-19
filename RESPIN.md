# Create LMDE Respin for Lenovo IdeaPad D330

## Prepare the Respin
1. Install [LMDE](https://linuxmint.com/download_lmde.php) into Virtualbox (or other virtualization or machine)

2. Open mintupdate and disable Kernel 6.1.0 and futures updates, then upgrade

3. Download [last v5.4.x generic amd64 kernel](https://kernel.ubuntu.com/mainline/)
- amd64/linux-image-unsigned-5.4.x-x-generic_5.4.x-x.x_amd64.deb
- amd64/linux-modules-5.4.x-x-generic_x-x.x_amd64.deb

4. Install
```
sudo dpkg -i linux-*.deb
```  

5. Reboot and choose 5.4.x kernel.

6. Remove 6.1.0 kernel
```
sudo apt remove *6.1.0-*
```   
7. Install some softwares and configs
```
# Upgrade
sudo apt update -y && sudo apt upgrade -y
# Dependencies and fixes
sudo apt install grub-customizer inotify-tools iio-sensor-proxy mesa-utils git v4l-utils gparted boot-repair -y
# Refresh screen
sudo wget -O /usr/bin/lenovod330-refreshscreen.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-refreshscreen.sh
sudo chmod +x /usr/bin/lenovod330-refreshscreen.sh
# Firefox gestures fix
echo export MOZ_USE_XINPUT2=1 | sudo tee /etc/profile.d/use-xinput2.sh
# Browser Freeze fix
sudo wget -O /usr/bin/browserfreezefix.sh https://raw.githubusercontent.com/lucasgabmoreno/browserfreezefix/main/browserfreezefix.sh
sudo chmod +x /usr/bin/browserfreezefix.sh
```

8. Install auto-cpufreq:
```
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
```
> Choose Option "i".

9. Install [Touchegg](https://github.com/JoseExposito/touchegg/releases/latest).

10. For [ACPI startup error](ACPI.md), open LMDE grub configuration file:
```
sudo xed /etc/default/grub.d/50_lmde.cfg
```
GRUB_CMDLINE_LINUX_DEFAULT must look like this:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 fbcon=nodefer video=efifb:nobgrt"
```
Open `Grub Customizer` > `General settings` > `kernel parameters`, and set:
```
quite splash loglevel=3 fbcon=nodefer video=efifb:nobgrt
```
> Into grub, don't use "Debian GNU/Linux" default as first option. It won't take kernel parameter. Use "Debian GNU/Linux, with Linux 5.4.*" instead.
---

## Make Respin
1. Download [Peguin Eggs](https://sourceforge.net/projects/penguins-eggs/files/DEBS/) and install
```
sudo dpkg -i eggs*amd64.deb
sudo apt install -f
```
2. Create dad
```
sudo eggs dad --default
```
3. Install Calamares
```
sudo eggs calamares --install
```
4. Produce
```
sudo eggs produce 
```
