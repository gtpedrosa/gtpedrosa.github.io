+++
title = "Using moderncv on Debian Fresh Installation"
author = ["Guilherme Pedrosa"]
date = 2022-08-22T23:05:00-03:00
tags = ["linux", "debian", "latex"]
draft = false
+++

The easiest way to install a minimal LaTeX installation to use moderncv was using the [debian package repository](https://packages.debian.org/search?keywords=texlive):

```bash
sudo apt install texlive
sudo apt install texlive-lang-portuguese
```

Note to self: I tried to install the vanilla texlive systemwide without the full installation (~7Gb) by using the graphical capability if _install-tl_ but could not get tlmgr to work properly, even after adding the installation path to my _.bashrc_.
