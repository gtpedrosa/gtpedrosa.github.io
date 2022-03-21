+++
title = "Setting up Debian 11 on my HP Pavillion dv7-6199us"
author = ["Guilherme Pedrosa"]
date = 2022-03-20T17:46:00-03:00
tags = ["linux", "debian", "driver", "Ansible", "chezmoi"]
draft = false
+++

The HP Pavillion dv7-6199us has been my notebook for over 10 years. I accidentally trashed my system and could not fix it when it crashed during an upgrade. This led me to format it over, which was long due. Taking advantage of my previous experience with my other HP, the 246, I tried to install Debian 11 instead of Ubuntu. Here are my other findings during the OS switch.

Debian does not come with non-libre software. This is the reason the wifi driver was not supported [previously](https://gtpedrosa.github.io/blog/installing-linux-on-hp-246-g6/). Following my notes, I was able to quickly set this up. Interestingly, I have found that the drivers are located at **/lib/firmware** which I did not know before trying a manual install. I ended up installing all the available driver options by issuing

```bash
# Wifi proprietary driver
sudo apt update && sudo apt install firmware-iwlwifi
ls /lib/firmware
```

Meanwhile, I have noticed the fan noise pretty loud since the startup. I tracked this issue to be related to my graphics card. I do not recall where I have found this info, but updating the graphic drivers did the trick:

```bash
# Avoid fan overwork
sudo apt-get install firmware-amd-graphics libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers xserver-xorg-video-all
```

These were quirks related to this device only. However, due to my recent system installation, I thought about how could I automate this process. My research showed that Ansible is quite a powerful tool worth exploring in this area. For simplicity sake, my first approach was to keep a bash script. It tracked all the software I needed and the commands necessary to set them up. I hope to turn it into an Ansible playbook in the future. Meanwhile here's the bash script:

```bash
# curl
sudo apt install curl

# pass
sudo apt install pass -y

# Install keychain to start ssh-agent if it isn't running
# https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login
sudo apt install keychain -y

# gpg keys
gpg --import ~/.gnupg/pubring.gpg
gpg --import ~/.gnupg/secring.gpg
# https://stackoverflow.com/questions/33361068/gnupg-there-is-no-assurance-this-key-belongs-to-the-named-user
# gpg --edit-key <KEY-ID>
# trust
# 5
# quit

# Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
~/.dropbox-dist/dropboxd

# Spotify
curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

# gnucash
# Install sqlite3 backend
sudo apt install libdbd-sqlite3 gnucash -y

# Install applet to fix battery status ("Estimating..." indefinetly")
#sudo add-apt-repository ppa:iaz/battery-status && sudo apt-get update
#sudo apt-get install battery-status

# Editors
sudo apt install emacs neovim -y
# emacs uninstall org 9.3 and org related packages. Install spacemacs-theme. Restart.

# Fish shell
sudo apt install fish -y

# i3
sudo apt install i3 -y

# librewolf
echo "deb [arch=amd64] http://deb.librewolf.net $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/librewolf.list
sudo wget https://deb.librewolf.net/keyring.gpg -O /etc/apt/trusted.gpg.d/librewolf.gpg
sudo apt update
sudo apt install librewolf -y

# dotfiles
sudo sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply gtpedrosa
sudo mv ./bin/chezmoi /bin/
rm -rf ./bin
# OBS: emacs agenda only worked after reinstalling org package. Theme was not applied

# pyenv
sudo curl https://pyenv.run | bash

# Calibre
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

# Zotero
# download latest version manually

# Hugo
# download latest version form github
https://github.com/gohugoio/hugo/releases/download/v0.95.0/hugo_0.95.0_Linux-64bit.deb
sudo dpkg -i ./Downloads/hugo_0.95.0_Linux-64bit.deb

# htop
sudo apt install htop

# frescobaldi
sudo apt install frescobaldi

# FreeCAD
sudo apt install freecad
# Download ODA converter for dwg import and install
# https://www.opendesign.com/guestfiles/oda_file_converter
```

This episode was a great learning experience OS-wise. As a side effect, I got my dotfiles cruft reduced and made them more portable. By the way, shoutout to [chezmoi](https://www.chezmoi.io/), which made the setup of the dotfiles a breeze.