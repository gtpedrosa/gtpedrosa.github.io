+++
title = "Fixing ever-growing kern.log, messages and syslog files on Debian"
author = ["Guilherme Pedrosa"]
date = 2022-03-06T22:49:00-03:00
tags = ["debian", "linux"]
draft = false
+++

After a Fresh install of Debian, I was suddenly surprised by the current lack of disk space to save a file. This post is a memo for my future self of how I managed to solve this issue.

In summary, the lack of disk space was caused by ever-growing logging messages stored on three files located in **/var/log**: messages, kern.log, and syslog. What messages? Specifically these:

```nil
guilherme@gtpedrosa: sudo tail syslog
Mar  5 12:11:50 gtpedrosa kernel: [  256.873658] pcieport 0000:00:1d.0: AER: Corrected error received: 0000:00:1d.0
Mar  5 12:11:50 gtpedrosa kernel: [  256.873661] pcieport 0000:00:1d.0: PCIe Bus Error: severity=Corrected, type=Physical Layer, (Receiver ID)
Mar  5 12:11:50 gtpedrosa kernel: [  256.873662] pcieport 0000:00:1d.0:   device [8086:9d18] error status/mask=00000001/00002000
Mar  5 12:11:50 gtpedrosa kernel: [  256.873662] pcieport 0000:00:1d.0:    [ 0] RxErr
Mar  5 12:11:50 gtpedrosa kernel: [  256.873669] pcieport 0000:00:1d.0: AER: Corrected error received: 0000:00:1d.0
Mar  5 12:11:50 gtpedrosa kernel: [  256.873679] pcieport 0000:00:1d.0: AER: can't find device of ID00e8
Mar  5 12:11:50 gtpedrosa kernel: [  256.873680] pcieport 0000:00:1d.0: AER: Corrected error received: 0000:00:1d.0
Mar  5 12:11:50 gtpedrosa kernel: [  256.873684] pcieport 0000:00:1d.0: PCIe Bus Error: severity=Corrected, type=Physical Layer, (Receiver ID)
Mar  5 12:11:50 gtpedrosa kernel: [  256.873688] pcieport 0000:00:1d.0:   device [8086:9d18] error status/mask=00000001/00002000
Mar  5 12:11:50 gtpedrosa kernel: [  256.873689] pcieport 0000:00:1d.0:    [ 0] RxErr
```

Having no clue how to proceed, the following resources shed some light on how I should approach the issue:

-   [Github gist](https://gist.github.com/Brainiarc7/3179144393747f35e5155fdbfd675554)
-   [Launchpad](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1521173)
-   [StackExchange](https://unix.stackexchange.com/questions/195360/my-var-log-is-mysteriously-filling-up-gbs-in-minutes-any-cure-before-i-re-ins)

Following the gist resource, I found that the offending Bus error was owed to my PCI (_Peripheral Computer Interface_) bridge. The bus info is exactly the one reported in the log files:

```nil
guilherme@gtpedrosa:/var/log$ sudo lshw -numeric
	*-pci:2
	     description: PCI bridge
	     product: Sunrise Point-LP PCI Express Root Port #9 [8086:9D18]
	     vendor: Intel Corporation [8086]
	     physical id: 1d
	     bus info: pci@0000:00:1d.0
	     version: f1
	     width: 32 bits
	     clock: 33MHz
	     capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
	     configuration: driver=pcieport
	     resources: irq:124 ioport:3000(size=4096) memory:b1000000-b10fffff
	   *-network
		description: Wireless interface
		product: RTL8723BE PCIe Wireless Network Adapter [10EC:B723]
		vendor: Realtek Semiconductor Co., Ltd. [10EC]
		physical id: 0
		bus info: pci@0000:03:00.0
		logical name: wlo1
		version: 00
		serial: b0:52:16:ff:33:9f
		width: 64 bits
		clock: 33MHz
		capabilities: pm msi pciexpress bus_master cap_list ethernet physical wireless
		configuration: broadcast=yes driver=rtl8723be driverversion=5.10.0-11-amd64 firmware=N/A ip=192.168.15.15 latency=0 link=yes multicast=yes wireless=IEEE 802.11
		resources: irq:16 ioport:3000(size=256) memory:b1000000-b1003fff
```

After identifying the key information I tried to rewrite the base registry manually. The current output was:

```nil
guilherme@gtpedrosa:/var/log$ sudo setpci -v -d 8086:9d18 CAP_EXP+0x8.w
0000:00:1d.0 (cap 10 @40) @48 = 000f
```

And the expected output should be **000e** (according to the gist author). However, after trying to overwrite it:

```nil
guilherme@gtpedrosa:/var/log$ sudo setpci -v -d 8086:9d18 CAP_EXP+0x8.w=0x0e
pcilib: sysfs_write: write failed: Operation not permitted
0000:00:1d.0 (cap 10 @40) @48 000e
```

I got permission denied. ****The only way to make sysfs\_write work was to disable secure boot****. Only then, the above command ran without issue. It took me quite a while to figure this piece out. However, this only halted the logs in the current session, meaning that after a restart it would grow again until I re-issued the command. This led me to alter the grub file, as per the launchpad suggestion. The final answer involved editing **/etc/default/grub** and replacing the existing **GURB\_CMD\_LINE\_LINUX\_DEFAULT** with the following:

```nil
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash pci=noaer"
```

Emphasis on the **pci=noaer** option. What this does, according to the [Linux Kernel manual](https://www.kernel.org/doc/html/v4.14/admin-guide/kernel-parameters.html), is to disable the PCI Express advanced logging. Note that **grub-update** is necessary. This was only possible after disabling secure boot as well. The _how-to_ is in one of the answers of the StackExchange link.

Sadly, this is only a workaround. Probably, as per [my previous post](https://gtpedrosa.github.io/blog/installing-linux-on-hp-246-g6/), and [this insight](https://askubuntu.com/questions/1104219/what-does-pci-noaer-or-pci-nomsi-mean), a hardware (my wireless driver) does not communicate with the kernel properly with MSI. Nonetheless, the HP notebook is ready for some serious work.