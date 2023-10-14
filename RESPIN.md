# Create LMDE Respin for Lenovo IdeaPad D330

## Prepare the Respin
1. Install [LMDE](https://linuxmint.com/download_lmde.php) into Virtualbox (or other virtualization or machine)
2. Open mintupdate and disable Kernel 6.1.0 and futures updates
3. Install some softwares and configs
```
# Upgrade
sudo apt update -y && sudo apt upgrade -y
# Dependencies and fixes
sudo apt install grub-customizer inotify-tools iio-sensor-proxy mesa-utils git v4l-utils gparted -y
# Refresh screen
sudo wget -O /usr/bin/lenovod330-refreshscreen.sh https://raw.githubusercontent.com/lucasgabmoreno/linuxmint_lenovod330/main/lenovod330-refreshscreen.sh
sudo chmod +x /usr/bin/lenovod330-refreshscreen.sh
# Firefox gestures fix
echo export MOZ_USE_XINPUT2=1 | sudo tee /etc/profile.d/use-xinput2.sh
# Browser Freeze fix
sudo wget -O /usr/bin/browserfreezefix.sh https://raw.githubusercontent.com/lucasgabmoreno/browserfreezefix/main/browserfreezefix.sh
sudo chmod +x /usr/bin/browserfreezefix.sh
```
4. Go to [Ubuntu's Kernel Mainline](https://kernel.ubuntu.com/~kernel-ppa/mainline/) and download the last 5.4.x generic amd64 files and install
```
sudo dpkg -i linux*.deb
sudo apt --fixbroken install
```
5. Reboot and choose 5.4.x kernel
```
sudo apt remove *6.1.0-* -y
```
6. Install auto-cpufreq:
```
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
```
Choose Option "i".
7. Install [Touchegg](https://github.com/JoseExposito/touchegg/releases/latest).
8. For [ACPI startup error](ACPI.md), open LMDE grub configuration file:
```
sudo xed /etc/default/grub.d/50_lmde.cfg
```
GRUB_CMDLINE_LINUX_DEFAULT must look like this:
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=3 fbcon=nodefer video=efifb:nobgrt"
```
To fix browser freeze use [this Browser Freeze Fix](https://github.com/lucasgabmoreno/browserfreezefix)

## Make Respin
1. Download []Peguin Eggs](https://sourceforge.net/projects/penguins-eggs/files/DEBS/) and install
```
sudo dpkg -i eggs*amd64.deb
sudo apt install -f
```
Create dad
```
sudo eggs dad --default
```
Install Calamares
```
sudo eggs calamares --install
```
Produce
```
sudo eggs produce 
```
