# KodeKloud Community FAQ

This document answers the most frequently asked questions in the KodeKloud Slack channels. We will be adding to this list periodically.

# Contents

* [Exam Environment](#exam-environment)
    * [Can I use an external monitor?](#can-i-use-an-external-monitor)
    * [Can I use multiple monitors?](#can-i-use-multiple-monitors)
    * [Can I use an external webcam?](#can-i-use-an-external-webcam)
    * [Does my microphone need to work?](#does-my-microphone-need-to-work)
    * [Do my speakers need to work?](#do-my-speakers-need-to-work)
    * [Can I use my own bookmarks?](#can-i-use-my-own-bookmarks)
    * [Can I paste settings for vi, aliases etc from my notepad?](#can-i-paste-settings-for-vi-aliases-etc-from-my-notepad)
    * [How many killer.sh sessions do I get?](#how-many-killersh-sessions-do-i-get)
    * [What are the system requirements for taking the exam?](#what-are-the-system-requirements-for-taking-the-exam)
    * [What ID is required?](#what-id-is-required)
* [Kubernetes CKA/CKAD](#kubernetes-ckackad)
    * [How do I backup etcd?](#how-do-i-backup-etcd)
    * [How do I restore etcd?](#how-do-i-restore-etcd)
    * [How do I install a CNI (or anything else)?](#how-do-i-install-a-cni-or-anything-else)
    * [How do I run Docker commands when Docker is removed?](#how-do-i-run-docker-commands-when-docker-is-removed)
* [Kubernetes Challenges](#kubernetes-challenges)
    * [I cannot complete Challenge 2](#i-cannot-complete-challenge-2)
* YAML Syntax
    * See the [dedicated YAML FAQ](./yaml-faq.md)
* [Useful Links](#useful-links)
    * [Pre-Exam](#pre-exam)
    * [All Exams](#all-exams)
    * [CKA/CKAD](#ckackad)
    * [CKS](#cks)
    * [Other](#other)

## Exam Environment

Probably *the* most asked questions! This pertains to the new PSI Bridge Proctoring Platform that went live for the Kubernetes exams on 25 June 2022.

Many people also ask "Can I use external webcam?", "Can I use bluetooth mouse?" etc. From the point of view of the system check, the PSI sofware will simply query the operating system. It will expect to find the following devices, and *it doesn't matter* how they are connected (built-in, wired, RF wireless, bluetooth, USB, via docking station, etc., etc.):

* One active monitor
* Mouse
* Keyboard
* Microphone
* Camera

In addition to the Q&A below, you can also watch [our video](https://youtu.be/1fSxM0_dtac) on this subject.

### Can I use an external monitor?

> Yes

...but read the next question too.


### Can I use multiple monitors?

> No

You are permitted to use one *active* monitor. All other monitors must be disabled, and the PSI Secure software will check your display settings to confirm only one monitor is active.

This can be the laptop display, or an externally connected display. If using an external monitor connected to laptop, the laptop display must be disabled, either using display settings or by closing the lid.

If using a desktop computer with multiple monitors, disable all but your best one in display settings.

**TIP**: You are strongly advised *not* to rely on a small laptop screen (like 13 or 14 inch). Your workspace will be extremely tiny, worse if you rely on scaling the font size up. A monitor of higher than HD resolution running at 100% scale and large enough that you can read the text is highly recommended. Anything less than full HD is seriously disadvantageous!

**IMPORTANT NOTE ABOUT MACBOOKS** From various discussions in slack, it appears that mirror mode is not supported by the PSI software and it is also not possible to disable the laptop display from display settings to have only external monitor enabled, meaning that you are stuck with the laptop display no matter how small it may be. If anybody knows how to set up a macbook to run external display only, please message in KodeKloud slack and tag `Alistair Mackay (KodeKloud)`, or raise an issue in this repo.

### Can I use an external webcam?

> Yes

If you are working with laptop lid closed, then this is your only option. It doesn't have to be mega-expensive, it should be full HD and work.

Due to the nature of the check-in process for the exam, it's actually easier to use an external webcam, since you have to move it around *a lot* to cover everything that the proctor requires you to video - including 360 of room, all of desk area (left, right, up, down), all around your head and wrists too.

Note that you should practice getting a clear shot of your ID using your webcam *well before* exam day. Even consider building something to hold the ID card steady using your kids lego or something :-) 

### Does my microphone need to work?

> Yes

Proctor needs to be able to hear if anybody is talking to you from outside the camera's view.

### Do my speakers need to work?

> No

Proctor will only communicate with you via webchat built into the PSI software.

### Can I use my own bookmarks?

> No

Because you cannot run your own browser. The only software that may be running on your desktop at exam time is the PSI software. Each question has several relevant links into the Kubernetes documentation. Clicking these links opens tabs in Firefox within the exam environment. You can visit any of the allowed documentation using the provided Firefox.

### Can I paste settings for vi, aliases etc from my notepad?

> No

The only software that may be running is the PSI software, therefore you must memorize such things and enter them up manually at the beginning of the exam.

### How many killer.sh sessions do I get?

> 2

The exam fee includes one free retake and two killer sessions. If you use both killer sessions and then subsequently fail on your first attempt, you do not get additional killer sessions for the retake. You need to purchase them separately. If you pass your exam without having used both killer sessions, the remaining session(s) remain valid until one year after the date you purchased the exam.

Should you fail twice, you have to purchase a new exam. You will then get two more free sessions included.

### What are the system requirements for taking the exam?

Please see [PSI Bridge Requirements](https://helpdesk.psionline.com/hc/en-gb/articles/4409608794260--PSI-Bridge-FAQ-System-Requirements) and [Exam System Requirements (Linux Foundation)](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-system-requirements-to-take-the-exam)

The PSI document states a minimum screen resolution of 1368x769, but we *really* would not recommend that. See the section on [monitors](#can-i-use-multiple-monitors) above.

See also this [detailed write-up on events for exam day](https://github.com/fireflycons/tips-for-CKA-CKAD-CKS).

### What ID is required

Any national or state government issued photo ID where the name exactly matches the name you gave when registering for the exam. If your primary ID is in a language that uses non-Latin characters (e.g. Arabic, Greek, Russian etc.), then you must provide an additional form of ID that has your name as written in English.

Please carefully read [Exam ID requirements](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-id-requirements-to-take-the-exam).

## Kubernetes CKA/CKAD

### How do I backup etcd?

See the dedicated [etcd FAQ](./etcd-faq.md)

### How do I restore etcd?

See the dedicated [etcd FAQ](./etcd-faq.md)
### How do I install a CNI (or anything else)?

If you are required to install any software or 3rd party Kubernetes applications, then the question will tell you where to obtain the files/packages you need.

Note that for e.g. cluster upgrades, then `apt` package manager should work exactly as you have practiced in labs.

### How do I run Docker commands when Docker is removed?

As you most likely know, the Dockershim layer is removed in Kubernetes 1.24. This means that the `docker` command is also likely not installed.

For examining and working with containers at that level, you should find that one, other or both of `crictl` and `podman` will be present, depending on the exam requirements.

* `podman` can be used for creating containers from Dockerfiles. It has the same arguments as `docker`, and fully supports Dockerfile syntax. It should be able to do most, if not all of what the `docker` command can. On newer versions of CentOS, `podman` is installed by default if you do `yum install docker`, and it places a shell script for the `docker` command which invokes `podman`.
* `crictl` can be used for controlling containers, like listing running containers and getting logs. It too has the same arguments as the corresponding `docker` commands.

Find out which of these are installed by running these commands in the terminal

```bash
which docker
which crictl
which podman
```

## Kubernetes Challenges

### I cannot complete Challenge 2

All the icons are green, yet it still says "tasks incomplete".

Notice the red arrow between `users` and `gop-fs-service`. Click this to reveal the final task.



## Useful Links

### Pre-Exam

* [Exam System Requirements (Linux Foundation)](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-system-requirements-to-take-the-exam)
* [PSI Bridge Requirements](https://helpdesk.psionline.com/hc/en-gb/articles/4409608794260--PSI-Bridge-FAQ-System-Requirements)
* [Exam Workspace Requirements](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-testing-environment-requirements-to-take-the-exam)
* [Exam ID requirements](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-id-requirements-to-take-the-exam)

### All Exams

* [Exam Desktop](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-user-interface)
* [Detailed write-up on exam procedure](https://github.com/fireflycons/tips-for-CKA-CKAD-CKS) by Alistair Mackay (KodeKloud)
* [Video presentation](https://youtu.be/1fSxM0_dtac) on the new exam environment

### CKA/CKAD

* [Exam Environment](https://docs.linuxfoundation.org/tc-docs/certification/tips-cka-and-ckad#cka-and-ckad-environment)
* [Allowed Documentation](https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed#certified-kubernetes-administrator-cka-and-certified-kubernetes-application-developer-ckad)

### CKS
* [Exam Environment](https://docs.linuxfoundation.org/tc-docs/certification/important-instructions-cks#cks-environment)
* [Allowed Documentation](https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed#certified-kubernetes-security-specialist-cks)

### Other

* [vim Cheat Sheet](https://vim.rtorr.com/)
* [tmux Cheat Sheet](https://opensource.com/article/20/7/tmux-cheat-sheet)

## Specific Questions About The Exam
* [Specific Questions About Exam](https://trainingsupport.linuxfoundation.org/). Login here with your Linux Foundation credentials. You can raise a ticket to ask questions about anything to do with the exam. The answers you receive here are the ultimate source of truth and trump anything you may read on this page or in any public discussion forums. Expect 2-3 days for a response.

Should a response from Linux Foundation contradict anything on this page, please reach out to a member of the support team in Slack. Thanks!

KodeKloud Team.

