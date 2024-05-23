# Linux - What is a "distro"?

* [What is Linux?](#what-is-linux)
* [What is a distro?](#what-is-a-distro)
    * [Red Hat](#red-hat)
    * [Debian](#debian)
    * [Others](#others)
* [A note about containers](#a-note-about-containers)

Firstly, "distro" is short for "distribution". A Linux distro is an opinionated distribution of the Linux operating system.

## What is Linux?

Linux is the core of the operating system, comprising mainly the kernel and the device drivers. The kernel is the identity of Linux and versions of it are released a few times a year. Windows also has a kernel, so Windows 10 and Windows 11 are different versions of the Windows kernel. The kernel provides a device independent interface to your computer and knows how to interface with the CPU, memory and hardware devices, abstracting away the differences between e.g. Intel and ARM processors. Device drivers are plugins to a kernel which manage the specific hardware on your computer - the disks, network interfaces, input/output devices etc. Developers from the various hardware manufacturers contribute device driver code to the Linux project for new hardware they create. The kernel provides [syscalls](https://en.wikipedia.org/wiki/System_call) for userspace software (everything that isn't part of the kernel itself) running to interact with the computer hardware.

In the Linux world, the kernel and device drivers are open source and are maintained by anyone who wants to involve themselves with the project, and is overseen by [Linus Torvalds](https://en.wikipedia.org/wiki/Linus_Torvalds), the creator of Linux.

## What is a distro?

A distro comprises the following:

1. A version of the Linux Kernel, selected by the distro's creators based on factors like the stability of it and the number of known issues.
1. The standard utilities (sed, awk, grep, ls, cat etc., etc.).
1. A package manager for the distro's specific package management system.
1. Other pieces of software chosen by the distro's creators, e.g. for a security focused distro like Kali Linux, it will include a lot of software for hacking, penetration testing etc.
1. A desktop GUI (if installed), of which there are many choices, e.g. Gnome, KDE.

Many distros are arranged into families based on a well-known core distro. The two main core distros are Red Hat and Debian, so a distro based on one of these will generally have the first three items from the list above taken from the parent distro, and the other two will be specific to that distro.

Some third party commercial software will refuse to run unless it detects it's installed on genuine RHEL. Not because it wouldn't actually run, but more down to the licensing and support agreements.

If you weren't aware, Android is also a Linux distro, specifically created for mobile devices!

Let's look at these two big players and some of the distros created from them.

### Red Hat

The core distro is Red Hat Enterprise Linux (RHEL) and has a commercial licencing model. This will usually be one major version of the Linux kernel *behind* what is currently available. Thus if the latest kernel is version 5, then RHEL will run on version 4. Why? Because it's battle tested and has many bug fixes and is therefore trusted for enterprise grade production workloads. RHEL is generally the Linux of choice for large corporations.

All these distros will use `yum`/`dnf` for package management

Some sub-distros based on Red Hat are

* CentOS Stream - Created by Red Hat. Uses a newer version of the kernel than RHEL. Should be safe for production use, but not guaranteed or supported by Red Hat for this. Used as a proving ground for what will go into the next GA version of RHEL.
* Fedora - Created by Red Hat. Uses the absolute latest version of everything. Targeted at people who want to test the latest features.
* Rocky Linux - Aims to use the same versions of everything used in the current version of RHEL, so seen as a free alternative for use with production workloads.
* Alma Linux - Similarly positioned to Rocky.
* Amazon Linux - a default choice for AWS EC2 instances, but can also be downloaded and run as a VM.
* Oracle Linux - Created by Oracle corp and can be bought with a support agreement for production workloads.

### Debian

Unlike RHEL, core Debian is free. If you run core Debian, this is generally considered production stable and like Red Hat, will not use the latest version of the kernel. This family uses the `apt` package manager.

Some sub-distros of Debian are

* Ubuntu - the most well known one, which also has many distros forked from it.
* Linux Mint
* Kali (mentioned above)
* Raspbian - Raspberry PI computers.

### Special Mention - Alpine

[Alpine](https://www.alpinelinux.org/) is a distro that's favored by people building Docker images, due to its extremely small size. The entire distribution is about 5 megabytes because it is cut down to just a shell and the basic command line tools, though many popular packages are ported to its package repository, which is accessed using the `apk` command. This minimalist distro also reduces the attack surface as less software available in a container means less that an attacker can do. See also the [note about containers](#a-note-about-containers) below.

### Others

There are literally hundreds of Linux distributions! However, if you create a piece of software that is a statically linked native code binary (which can be done using languages like golang or C/C++), then that software will run on any of these distros without modification, as long as that distro is on the same CPU architecture that your program was built on.

See [this infographic](https://upload.wikimedia.org/wikipedia/commons/a/ad/2023_Linux_Distributions_Timeline.svg) to get an idea of just how many there are!


## A note about containers

When you run containers in Docker or Kubernetes, the base images from which you build your containers are also based on distros. The important thing to note here is that the image *does not* contain a kernel. It will only contain items 2, 3 and 4 from the list above. This is because the container will use the kernel of the host machine, and you cannot run GUI desktops inside containers.

Some sharper eyed students have noticed the following when running our labs that are based on CentOS:

```text
[bob@student-node ~]$ cat /etc/os-release
NAME="CentOS Stream"
VERSION="8"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="8"
PLATFORM_ID="platform:el8"
PRETTY_NAME="CentOS Stream 8"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:8"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 8"
REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream"

[bob@student-node ~]$ uname -a
Linux student-node 5.4.0-1106-gcp #115~18.04.1-Ubuntu SMP Mon May 22 20:46:39 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
[bob@student-node ~]$
```

Note that when we look at `/etc/os-release` it is telling us `CentOS`, but when we run `uname -a` we see `Ubuntu`.

Why is this?

It indicates that the lab is running inside a container. The container is built from a CentOS distro, however the machine hosting the container is running Ubuntu on a kernel version of 5.4.0. We can also tell from this that the host is running in Google Cloud! Remember that the kernel is the kernel and it doesn't matter whether there's Ubuntu, Red Hat or anything else on top of it in the host machine. The distro in the container will access the same syscalls in the kernel which adhere to a standard.

You should always check `/etc/os-release` to identify the distro, not `uname`.
