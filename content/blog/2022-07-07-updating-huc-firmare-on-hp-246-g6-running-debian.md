+++
title = "Updating HuC firmare on HP 246 G6 running Debian"
author = ["Guilherme Pedrosa"]
date = 2022-07-10T12:38:00-03:00
draft = false
+++

After noticing a warning on my boot screen about missing firmware I tried to update the system. In the process, I have received messages similar to the one below:

```bash
W: Possible missing firmware /lib/firmware/i915/bxt_dmc_ver1_07.bin for module i915
W: Possible missing firmware /lib/firmware/i915/skl_dmc_ver1_27.bin for module i915
```

These two resources were really helpful to me:

-   [vjaquez post](https://blogs.igalia.com/vjaquez/2017/12/07/enabling-huc-for-sklkbl-in-debiantesting/)
-   [Unix Stack Exchange Thread](https://unix.stackexchange.com/questions/556946/possible-missing-firmware-lib-firmware-i915-for-module-i915)

From the first resource, I have found what the heck is HuC:

> HuC is a firmware, loaded by i915 kernel module, designed to offload some of the media functions from the CPU to GPU. One of these functions is bitrate control when encoding. HuC saves unnecessary CPU-GPU synchronization.

Which puts things into perspective, even though I haven't noticed any graphics issue besides a Matlab running on OpenGL warning.

As a solution, the stackexchange post taught me about apt-file, an application that indexes and searches in my available repositories for a particular file. After its installation, I tried to find out the offending drivers:

```bash
apt-file search skl_huc
```

```text
firmware-misc-nonfree: /lib/firmware/i915/skl_huc_2.0.0.bin
firmware-misc-nonfree: /lib/firmware/i915/skl_huc_ver01_07_1398.bin
```

And install the package _firmware-linux_:

```bash
sudo apt install firmware-linux
```

After this, the update went smoothly and the error messages on boot vanished.
