# Linux - What is a "distro"?

Firstly, "distro" is short for "distribution". A Linux distro is an opinionated distribution of the Linux operating system.

## What is Linux

Linux is the core of the operating system, comprising mainly the kernel and the device drivers. The kernel is the identity of Linux and versions of it are released a few times a year. Windows also has a kernel, so Windows 10 and Windows 11 are different versions of the Windows kernel. Device drivers are plugins to a kernel which manage the hardware on your computer - the disks, network interfaces, input/output devices etc.

In the Linux world, the kernel and device drivers are open source and are maintained by anyone who wants to involve themselves with the project, and is overseen by [Linus Torvalds](https://en.wikipedia.org/wiki/Linus_Torvalds), the creator of Linux.

## What is a distro?

A distro comprises the following:

* A version of the Linux Kernel.
* The standard utilities (sed, awk, grep, ls, cat etc., etc.).
* A package manager for the distro's specific package management system.
* A desktop GUI (if installed), of which there are many choices, e.g. Gnome, KDE.
* Other pieces of software chosen by the distro's creators, e.g. for a security focused distro like Kali Linux, it will include a lot of software for hacking, penetration testing etc.

Many distros are arranged into families based on a well-known core distro. The two main core distros are Red Hat and Debian, so a distro based on one of these will generally have the first three items from the list above taken from the parent distro, and the other two will be specific to that distro.

Let's look at these two big players and some of the distros created from them.

### Red Hat

The core distro is Red Hat Enterprise Linux (RHEL) and has a commercial licencing model. This will usually be one major version of the Linux kernel *behind* what is currently available. Thus if the latest kernel is version 5, then RHEL will run on version 4. Why? Because it's battle tested and has many bug fixes and is therefore trusted for enterprise grade production workloads. RHEL is generally the Linux of choice for large corporations.

All these distros will use `yum`/`dnf` for package management

Some sub-distros based on Red Hat are

* CentOS Stream - Created by Red Hat. Uses a newer version of the kernel than RHEL. Should be safe for production use, but not guaranteed or supported by Red Hat for this.
* Fedora - Created by RedHat. Uses the absolute latest version of everything. Targeted at people who want to test the latest features.
* Rocky Linux - Aims to use the same versions of everything used in the current version of RHEL, so seen as a free alternative for use with production workloads.
* Alma Linux - Similarly positioned to Rocky.
* Oracle Linux - Created by Oracle corp and can be bought with a support agreement.

### Debian

Unlike RHEL, core Debian is free, and is called "Debian". If you run core Debian, this is generally considered production stable and like RedHat, will not use the latest version of the kernel. This family uses the `apt` package manager.

Some sub-distros of Debian are

* Ubuntu - the most well known one.
* Linux Mint
* Kali (mentioned above)