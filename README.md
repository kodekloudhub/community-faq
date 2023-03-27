# KodeKloud Community FAQ

This document answers the most frequently asked questions in the KodeKloud Slack channels. We will be adding to this list periodically.

# Contents

* [Buying the Exam](#buying-the-exam)
* [Exam Environment](#exam-environment)
    * [PSI Bridge](#psi-bridge)
        * [Students' own notes on the Exam Environment](#students-own-notes-on-the-exam-environment)
        * [Can I use an external monitor?](#can-i-use-an-external-monitor)
        * [Can I use multiple monitors?](#can-i-use-multiple-monitors)
        * [Can I use an external webcam?](#can-i-use-an-external-webcam)
        * [Does my microphone need to work?](#does-my-microphone-need-to-work)
        * [Do my speakers need to work?](#do-my-speakers-need-to-work)
        * [Can I use a headset?](#can-i-use-a-headset)
        * [Can I use a corporate device?](#can-i-use-a-corporate-device)
        * [Can I request a break?](#can-i-request-a-break)
        * [What are the system requirements for taking the exam?](#what-are-the-system-requirements-for-taking-the-exam)
        * [What ID is required?](#what-id-is-required)
        * [How do I prepare for exam day?](https://github.com/fireflycons/tips-for-CKA-CKAD-CKS)&nbsp;&nbsp;&nbsp;[![external link](./img/open-external-link-icon-16-16.png)](https://github.com/fireflycons/tips-for-CKA-CKAD-CKS)
        * [Issues with launching the exam](#issues-with-launching-the-exam)
        * [What happens if there are issues during the exam?](#what-happens-if-there-are-issues-during-the-exam)
        * [How long until I get my result?](#how-long-until-i-get-my-result)
        * [If I fail, how soon can I schedule a retake?](#if-i-fail-how-soon-can-i-schedule-a-retake)
        * [If I raise a support ticket, when will it be answered?](#if-i-raise-a-support-ticket-when-will-it-be-answered)
    * [Performance Based Exams](#performance-based-exams)
        * [Can I use my own bookmarks?](#can-i-use-my-own-bookmarks)
        * [Can I open multiple terminal sessions?](#can-i-open-multiple-terminal-sessions)
        * [Can I paste settings for vi, aliases etc from my notepad?](#can-i-paste-settings-for-vi-aliases-etc-from-my-notepad)
        * [How do I remove the nag dialog when pasting into the terminal application?](#how-do-i-remove-the-nag-dialog-when-pasting-into-the-terminal-application)
        * [What does the environment look like?](#what-does-the-environment-look-like)
        * [How is the exam scored?](#how-is-the-exam-scored)
        * [What if I want to dispute my score?](#what-if-i-want-to-dispute-my-score)
* [Kubernetes Certifications](#kubernetes-ckackad)
    * [How many killer.sh sessions do I get?](#how-many-killersh-sessions-do-i-get)
    * [How does killer.sh compare to the real thing?](#how-does-killersh-compare-to-the-real-thing)
    * [Where can I find other practice scenarios for free?](#where-can-i-find-other-practice-scenarios-for-free)
    * [How do I backup etcd?](#how-do-i-backup-etcd)
    * [How do I restore etcd?](#how-do-i-restore-etcd)
    * [How do I install a CNI (or anything else)?](#how-do-i-install-a-cni-or-anything-else)
    * [How do I run Docker commands when Docker is removed?](#how-do-i-run-docker-commands-when-docker-is-removed)
    * [How do I diagnose a crashed API Server?](#how-do-i-diagnose-a-crashed-api-server)
    * [How-to: Install Ingress in the KodeKloud playgrounds](#how-to-install-ingress-in-the-kodekloud-playgrounds)
* [Other](#other)
    * [Labs are broken/crashing/not loading](#labs-are-brokencrashingnot-loading)
    * [How do I copy/paste in VSCode integrated terminal window?](#how-do-i-copypaste-in-vscode-integrated-terminal-window)
    * [I can't get out of vi!](#i-cant-get-out-of-vi)
* YAML Syntax
    * See the [dedicated YAML FAQ](./docs/yaml-faq.md)
* [Useful Links](#useful-links)
    * [Pre-Exam](#pre-exam)
    * [All Exams](#all-exams)
    * [CKA/CKAD](#ckackad)
    * [CKS](#cks)
    * [Other](#other)


# Buying the Exam

To buy any exam run by The Linux Foundation, you need to first sign up with [The Linux Foundation](https://www.linuxfoundation.org/). Once you have an account, known as an LFID, then you can go to their [training portal](https://trainingportal.linuxfoundation.org/) to purchase the exam. For Kubernetes exams, you get two killer.sh sessions included in the purchase. More on this further down this document.

With most of these exams, you have one year from the date of purchase in which to schedule *and* take the exam and this time includes scheduling any free retake that may be offered. You do not have to schedule immediately at time of purchase.

DO NOT LEAVE IT UNTIL THE LAST MINUTE TO SIT THE EXAM!!!

If you do that, and you have only days remaining before the validity expires, what are you going to do if there are issues with the exam environment (these are not infrequent) which means that you fail to complete, or even start the exam? You should appear for your first attempt *at least* one month before the expiry in case of issues like this. If your exam is credited back to you due to issues like this, then you still have to do this and the free retake if you require it within the one year period.

# Exam Environment

## PSI Bridge

Probably *the* most asked questions!</br></br>This pertains to the new PSI Bridge Proctoring Platform that went live for the Kubernetes exams on 25 June 2022. This provides a Linux XFCE desktop VDI for the exam environment. You may use any of the applications it provides in any way you see fit, however the only useful ones are `Terminal`, `Firefox` and `Mousepad` (for note taking). Firewalls prevent you from browsing anything other than allowed documentation. The terminal application connects to a remote host, thus the File Manager app is of no use, and for the same reason, Mousepad can't be used to edit exam files unless you edit them there, then paste into `vi` (not recommended).

Many people also ask "Can I use external webcam?", "Can I use bluetooth mouse?" etc. From the point of view of the system check, the PSI software will simply query the operating system. It will expect to find the following devices, and *it doesn't matter* how they are connected (built-in, wired, RF wireless, bluetooth, USB, via docking station, etc., etc.):

* One active monitor
* Mouse
* Keyboard
* Microphone
* Camera

In addition to the Q&A below, you can also watch [our video](https://youtu.be/1fSxM0_dtac) on this subject.

### Students' own notes on the Exam Environment

Download [this PDF](./student-exam-experiences.pdf) of curated student experiences taken from our Slack channels.

### Can I use an external monitor?

> Yes

...but read the next question too.


### Can I use multiple monitors?

> No

You are permitted to use one *active* monitor. All other monitors must be disabled, and the PSI Secure software will check your display settings to confirm only one monitor is active.

This can be the laptop display, or an externally connected display. If using an external monitor connected to laptop, the laptop display must be disabled:

* **Windows** - This can be done from Display Settings (Windows key + P)
* **Mac** - You must set it up in  [clamshell mode](https://svalt.com/blogs/svalt/76622081-laptop-clamshell-setup), but this will require external camera, keyboard, mouse and possibly microphone too, if the external camera is not fitted with one already - test the mic first!</br>If using an Intel chipset Mac (pre-M1 versions), beware of cooling issues!

If using a desktop computer with multiple monitors, disable or disconnect all but your best one.

**TIP**: You are strongly advised *not* to rely on a small laptop screen (like 13 or 14 inch). Your workspace will be extremely tiny, worse if you rely on scaling the font size up. A monitor of higher than HD resolution running at 100% scale and large enough that you can read the text is highly recommended. Anything less than full HD is seriously disadvantageous! See the [image](#what-does-the-environment-look-like) further down this page.

The Linux Foundation recommends 15 inch or greater display.

### Can I use an external webcam?

> Yes

If you are working with laptop lid closed, then this is your only option. It doesn't have to be mega-expensive, it should be full HD and work.

Due to the nature of the check-in process for the exam, it's actually easier to use an external webcam, since you have to move it around *a lot* to cover everything that the proctor requires you to video - including 360 of room, all of desk area (left, right, up, down), all around your head and wrists too.

Note that you should practice getting a clear shot of your ID using the webcam you intend to use in the exam *well before* exam day using your operating system's camera app. Even consider building something to hold the ID card steady using your kids Lego or something :smiley:. See [here](https://github.com/fireflycons/tips-for-CKA-CKAD-CKS#launching-the-exam) for an example that has been used successfully in an exam check-in process.

### Does my microphone need to work?

> Yes

Proctor needs to be able to hear if anybody is talking to you from outside the camera's view.

### Do my speakers need to work?

> No

Proctor will only communicate with you via webchat built into the PSI software.

### Can I use a headset?

> No

Proctor needs to see your ears to ensure that you are not getting some kind of external communication that could help you. Since speakers are not required, this also rules out headsets.

### Can I use a corporate device?

> Unwise

Use of corporate devices or laptops is not recommended, unless you have an account on it with full local administrator rights. There may be many programs and services mandated by company policy running on the device which are incompatible with PSI software and must be stopped. Bear in mind that stopping these programs may in violation of such policies.

Connecting via a corporate network is also not recommended as company firewall policy may block ports that are required by the exam software. Bear in mind that most companies install a mandatory VPN which kicks in if you use the device from outside of the office - ergo it means you are still connected via the corporate network, so the statements in the previous sentence still apply.

See also [launching the exam](https://github.com/fireflycons/tips-for-CKA-CKAD-CKS#launching-the-exam)

### Can I request a break?

> Yes

Press the "Request Break" button at top left of the PSI application, if you need to leave the keyboard for any reason. It can be seen in the [image](#what-does-the-environment-look-like) below.

**This is not recommended as the countdown timer does not stop**! Ensure you've done what you need to do before beginning the exam :wink:.

### How do I remove the nag dialog when pasting into the terminal application?

In the terminal application, select `Edit -> Preferences`. Uncheck `Show unsafe paste dialog`.

You can practice this in killer.sh before the exam.

### What are the system requirements for taking the exam?

**IMPORTANT**
* Linux is not supported _except_ for Ubuntu 18.04, 20.04 and 22.04.

Mac M1 _is_ supported.

Please see [PSI Bridge Requirements](https://helpdesk.psionline.com/hc/en-gb/articles/4409608794260--PSI-Bridge-FAQ-System-Requirements) and [Exam System Requirements (Linux Foundation)](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-system-requirements-to-take-the-exam)

The PSI document states a minimum screen resolution of 1368x769, but we *really* would not recommend that. See the section on [monitors](#can-i-use-multiple-monitors) above.

See also this [detailed write-up on events for exam day](https://github.com/fireflycons/tips-for-CKA-CKAD-CKS).

### What ID is required?

Any national or state government issued photo ID where the name exactly matches the name you gave when registering for the exam. If your primary ID is in a language that uses non-Latin characters (e.g. Arabic, Greek, Russian etc.), then you must provide an additional form of ID that has your name as written in English.

Please carefully read [Exam ID requirements](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-id-requirements-to-take-the-exam).

### Issues with launching the exam

Please read the [PSI Bridge FAQ](https://helpdesk.psionline.com/hc/en-gb/sections/360013179931-PSI-Bridge-FAQ) BEFORE you appear for the exam so you know what kind of setup issues you may face.

### What happens if there are issues during the exam?

No infrastructure is perfect! Be that KodeKloud labs, killer.sh or the exam environment. There may be issues that cause the exam to slow down or even disconnect in the middle of your session. Some issues are beyond the control of the environment provider (KodeKloud, PSI, etc), and include but probably not limited to:

* Issue with your own broadband provider.
* Issue with some third party network provider on the route between your own broadband provider and PSI's exam environment. This would add latency (lagging) or disconnects.
* The route between your location and the nearest cloud region has many hops or has slow sections (again adds latency). Doesn't matter how fast your own broadband provider is. If the route goes through a slow section, then that is the maximum speed you will attain. Think traffic jam - having a Ferrari won't get you through it any faster!
* Issue within the cloud provider used by PSI (AWS, GCP, Azure - don't know which they actually do use).
* Issue with PSI themselves.

The first two and to a certain extent the third are more likely if you live in, or the route crosses countries with poorly maintained infrastructure or political instability. What I'm getting at is it is not *always* PSI's fault! If you are still connected to the proctor, then they will generally try to help but it is not always successful. In the event that your exam finishes incomplete due to technical issues, you must [raise a ticket with Linux Foundation](https://trainingsupport.linuxfoundation.org/) explaining clearly what happened. In most cases they will credit your exam back to you.

### How long until I get my result?

> 24 hours

For the Linux Foundation online proctored exams, you will receive the result via email to the address registered to your Linux Foundation account. The response comes in not less than 24 hours, but can occasionally be longer.

If you've been waiting more than 48 hours, raise a [support ticket](https://trainingsupport.linuxfoundation.org/). Be sure to check it's not gone into your junk folder.

EMail domains associated with Linux Foundation are as follows. You can configure your email client to not treat any of these as spam.

* `linuxfoundation.org`
* `thoughtindustries.com`
* `credly.com`

### If I fail, how soon can I schedule a retake?

> Immediately

For exams with an included free retake, you may log into the training portal and schedule your retake as soon as you know you have failed.

Remember that the retake must also fall within the one year period since the date of exam purchase.

### If I raise a support ticket, when will it be answered?

Expect _at least 3 business days_ for a response. If you raise it on a Friday, you're unlikely to hear back before the following Wednesday. They don't work weekends or US public holidays.

## Performance Based Exams

Performance based exams (as opposed to Multiple Choice Question) are provided in a virtual desktop (VDI) within the PSI Bridge software. This VDI is a Linux XFCE desktop running on top of Ubuntu. Kubernetes and LFCS fall in this category.

### Can I use my own bookmarks?

> No

Because you cannot run your own browser. The only software that may be running on your desktop at exam time is the PSI software. Each question has several relevant links into the Kubernetes documentation. Clicking these links opens tabs in Firefox within the exam environment. You can visit any of the allowed documentation using the provided Firefox.</br>You may open multiple tabs in Firefox, however a question may state that you can only open one additional tab on a particular topic.

### Can I open multiple terminal sessions?

> Yes

Either multiple instances of the terminal emulator app, multiple tabs within the terminal emulator, or both. We would encourage you to do so. This is useful when editing manifests. Have the manifest open in `vi` in one terminal, and a command prompt in the other. Edit the YAML and save without exiting (`:w`). In the other terminal, apply. Repeat until the bugs in the YAML are out.

### Can I paste settings for vi, aliases etc from my notepad?

> No

The only software that may be running is the PSI software, therefore you must memorize such things and enter them up manually at the beginning of the exam.

### What does the environment look like?

![Image: The Linux Foundation](./img/LF-Remote-Desktop-070722d.png)
[Image: The Linux Foundation]

### How is the exam scored?

There will usually be several tasks associated with a question. You will obtain credit for each part of the question correctly answered.

Scoring is done by a grading script, which examines the end state of the system. It does not consider how you got there, meaning you can solve a question by any valid means.

### What if I want to dispute my score?

This is what The Linux Foundation says:

>   We offer an Exam rescoring service, but the turnaround time is 4+ weeks right now due to the current workload of the Exam Tech Support team. What the rescore service provides is a manual scoring of your exam by the Exam Tech Support team that can then be compared to the automated scoring that was initially performed by the grading scripts. Due to the manual nature of the work, the rescore service does cost $150 USD. (It is worth bearing in mind that rescores rarely result in conversion of a non-passing score. This is because the grading scripts have been time tested and continuously refined; additionally, the likelihood of having incorrectly graded a question or two is very low since we grade on outcomes (end state of the system), not the path the user took to get there. Should the rescore result in a passing grade, we would refund the fee to you.)<br/><br/>
Exam servers are decommissioned within a few days from the Exam date, so if you would like to go with the rescore service, please complete payment ASAP for the rescoring fee at –https://trainingportal.linuxfoundation.org/products/certification-exam-manual-rescore-fee-150.

# Kubernetes Certifications

### How many killer.sh sessions do I get?

> 2

Please see [killer.sh](./docs/killer-sh.md) FAQ page.

### How does killer.sh compare to the real thing?

> Very closely

Please see [killer.sh](./docs/killer-sh.md) FAQ page.

### Where can I find other practice scenarios for free?

For the following links, unless stated interactive lab environment you will need either your own cluster ([minikube](https://minikube.sigs.k8s.io/), [kind](https://kind.sigs.k8s.io/) or one you've built with kubeadm).

* CKA
    * https://killercoda.com/killer-shell-cka (interactive lab environment)
* CKAD
    * https://killercoda.com/killer-shell-ckad (interactive lab environment)
    * https://github.com/dgkanatsios/CKAD-exercises
* CKS
    * https://killercoda.com/killer-shell-cks (interactive lab environment)


### How do I backup etcd?

See the dedicated [etcd FAQ](./docs/etcd-faq.md)

### How do I restore etcd?

See the dedicated [etcd FAQ](./docs/etcd-faq.md)
### How do I install a CNI (or anything else)?

You will *not* be expected to memorize download locations for third party tools you may have downloaded in course labs. If you are required to install any software or 3rd party Kubernetes applications, then the question will tell you where to obtain the files/packages you need.

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

### How do I diagnose a crashed API Server?

See the [Crashed API Server](./docs/diagnose-crashed-apiserver.md) page.

### How-to: Install Ingress in the KodeKloud playgrounds

See [this guide](./docs/howto-install-ingress-on-kk-playground.md).

# Other

### Labs are broken/crashing/not loading

Please see [this guide](./docs/lab-issues.md)

### How do I copy/paste in VSCode integrated terminal window?

Some of our courses use a browser embedded version of VSCode, e.g. Terraform and some of the programming courses. Getting copy and paste to work can be challenging!

Please see [this guide](./docs/vscode-tips.md).

### I can't get out of vi!

For this and other `vi` tips, see [vi-101](./docs/vi-101.md)

# Useful Links

### Pre-Exam

* [Exam System Requirements (Linux Foundation)](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-system-requirements-to-take-the-exam)
* [PSI Bridge Requirements](https://helpdesk.psionline.com/hc/en-gb/articles/4409608794260--PSI-Bridge-FAQ-System-Requirements)
* [Exam Workspace Requirements](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-testing-environment-requirements-to-take-the-exam)
* [Exam ID requirements](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-id-requirements-to-take-the-exam)

### All Exams

* [Exam Desktop](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-user-interface)
* [Exam Preparation Checklist](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-preparation-checklist)
    * [Checklist Items](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-preparation-checklist#checklist-items)
    * [Name Verification](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-preparation-checklist#checklist-items)
    * [Platform Selection](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-preparation-checklist#checklist-items) - For LFCS you may select CentOS or Ubuntu. Bear in mind that KodeKloud LCFS course is delivered on CentOS, so you should select this option.
    * [Test Accommodations](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-preparation-checklist#test_accommodations) - For those with disabilities.
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
* [Specific Questions About Exam](https://trainingsupport.linuxfoundation.org/). Login here with your Linux Foundation credentials. You can raise a ticket to ask questions about anything to do with the exam. The answers you receive here are the ultimate source of truth and trump anything you may read on this page or in any public discussion forums. Expect _at least 3 business_ days for a response. They don't work weekends or US public holidays.

Should a response from Linux Foundation contradict anything on this page, please reach out to a member of the support team in Slack. Thanks!

KodeKloud Team.

