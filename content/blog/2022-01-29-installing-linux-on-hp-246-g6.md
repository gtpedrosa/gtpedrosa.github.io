+++
title = "Installing Linux on HP 246 G6"
author = ["Guilherme Pedrosa"]
date = 2022-01-29T15:43:00-03:00
tags = ["linux", "debian", "driver"]
draft = false
+++

Trying to speed-up my notebook HP 246 G6, I decided to upgrade my HD to a SSD. While at it, I have also decided to switch from Windows to Ubuntu. However, things did not go as smooth as I thought they would.

Firstly, I could not flash a new Ubuntu image successfully on my 16GB CruzerBlade thumbdrive. I used the [Balena Etcher electron app](https://www.balena.io/etcher/). In case you have never used it before, just issue the following in the command line to get it running:

```bash
sudo ./balenaEtcher-1.7.3-x64.AppImage
```

I do not remeber why, but it is worth noticing that running without privileges I ran into trouble. Same thing for **Gparted** used to format the CruzerBlade. I had to run it with ****sudo**** in order to work and format the thumbdrive, which would not work otherwise.

Image flashed, I moved on to installation. To select the booting device on a HP machine, press ****F9****. Ubuntu GUI for installation appeared after HD check, but it would freeze before the installation process effectively started. Mind you this was Ubuntu 20.04 and found [I was not alone with this issue](https://appuals.com/how-to-fix-ubuntu-20-04-installer-stuck-at-updates/). Without any success resolving it, I decided to give Debian a try.

I chose to download the DVD image, and re-flashed the CruzerBlade. Installation ran smoothly until the "Setup connection" part. It would not recognize my Wifi driver. After installation, I had add my user to sudo:

```bash
su -
usermod -aG sudo username
exit
```

And restart the PC to take effect. To see if it worked, try to find ****sudo**** in the groups listed by

```bash
groups
```

Before issuing any commands, I also had to remove the "CD Rom" drives as source for other software in Synaptic. Otherwise, no internet mirrors were reached for updates. Now I could finally update the system and download new software.

First thing to do is to findout the driver, which was easy after some search for the right command:

```bash
lspci
```

It gave me that my Wireless Network Adapter was the Realtek RTL8723BE. Again, I was not the only one in trouble and found an excellent guide [here.](https://trendoceans.com/how-to-fix-rtl872be-no-wifi-network-connection-in-debian/) However, My fix was much shorter as It was already bundled in a [debian mirror in version 10](https://debian.pkgs.org/10/debian-nonfree-amd64/firmware-realtek%5F20190114-2%5Fall.deb.html) and I had just installed Debian 11 LTS. So after installing it (with mirrors working now):

```bash
sudo apt install firmware-realtek
```

I had it working. I am writing this as a reminder to my future self of this little saga to get the notebook up and running.