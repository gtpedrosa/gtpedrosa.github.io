+++
title = "Building Emacs from source"
author = ["Guilherme Pedrosa"]
date = 2020-04-12T10:59:00-03:00
tags = ["emacs"]
draft = false
+++

Steps needed to install emacs locally, mantaining pre-existing installation intact. In the end you will two different versions of emacs running in your system.

-   [Install dependencies:](https://www.emacswiki.org/emacs/EmacsSnapshotAndDebian)

<!--listend-->

```bash
sudo apt-get install autoconf automake libtool texinfo build-essential xorg-dev libgtk-3-dev libjpeg-dev libncurses5-dev libdbus-1-dev libgif-dev libtiff-dev libm17n-dev libpng-dev librsvg2-dev libotf-dev libgnutls28-dev libxml2-dev libxpm-dev
```

-   [Download emacs from a nearby mirror](https://www.gnu.org/software/emacs/download.html)
-   Extract downloaded file. In this case it is _emacs-26.3.tar.xz_, and go to the extracted folder:

<!--listend-->

```bash
cd ~/Downloads
tar -xf emacs-26.3.tar.xz
cd emacs-26.3.tar.xz
```

-   Run _configure_ setting the prefix to the local folder in home directory:

<!--listend-->

```bash
./configure --with-mailutils --prefix="${HOME}/local"
```

-   Build the components and istall it:

<!--listend-->

```bash
make
make install
```

To run it, issue:

```bash
/home/local/bin/emacs
```

The local installation, if any, should still work normally.
