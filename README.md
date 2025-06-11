# KodeKloud Community FAQ

This document answers the most frequently asked questions in the KodeKloud social channels. We will be adding to this list periodically.

First and foremost, please be aware of our [Community Guidelines](./docs/code-of-conduct.md), thank you! :smile:

# Contents

* [KodeKloud Forums](#kodekloud-forums)
* [KodeKloud Platform](#kodekloud-platform)
    * [I have a question about payments or subscriptions](#i-have-a-question-about-payments-or-subscriptions)
    * [I cannot access labs from Udemy](#i-cannot-access-labs-from-udemy)
* [Purchasing Exams Operated by Linux Foundation](#purchasing-exams-operated-by-linux-foundation)
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
        * [The certifications are *so* expensive! What about a discount?](#the-certifications-are-so-expensive-what-about-a-discount)
    * [Performance Based Exams](#performance-based-exams)
        * [Can I use my own bookmarks?](#can-i-use-my-own-bookmarks)
        * [Can I open multiple terminal sessions?](#can-i-open-multiple-terminal-sessions)
        * [How do I copy/paste in the exam terminal?](#how-do-i-copypaste-in-the-exam-terminal)
        * [Can I paste settings for vi, aliases etc from my notepad?](#can-i-paste-settings-for-vi-aliases-etc-from-my-notepad)
        * [Can I install packages or download *anything* to the exam terminal?](#can-i-install-packages-or-download-anything-to-the-exam-terminal)
        * [Will I be failed if I click a link that is outside of allowed docs?](#will-i-be-failed-if-i-click-a-link-that-is-outside-of-allowed-docs)
        * [How do I remove the nag dialog when pasting into the terminal application?](#how-do-i-remove-the-nag-dialog-when-pasting-into-the-terminal-application)
        * [What does the environment look like?](#what-does-the-environment-look-like)
        * [How is the exam scored?](#how-is-the-exam-scored)
        * [What if I want to dispute my score?](#what-if-i-want-to-dispute-my-score)
    * [Kubernetes Certifications](#kubernetes-ckackad)
        * [About the Kubernetes exam environments](#about-the-kubernetes-exam-environments)
        * [What are the similarities/differences between CKA and CKAD?](#what-are-the-similaritiesdifferences-between-cka-and-ckad)
        * [How many killer.sh sessions do I get?](#how-many-killersh-sessions-do-i-get)
        * [How does killer.sh compare to the real thing?](#how-does-killersh-compare-to-the-real-thing)
        * [How do I get some SERIOUS practice?](#how-do-i-get-some-serious-practice)
        * [How do I upgrade a cluster?](#how-do-i-upgrade-a-cluster)
        * [How do I backup etcd?](#how-do-i-backup-etcd)
        * [How do I restore etcd?](#how-do-i-restore-etcd)
        * [What's the deal with jsonpath and custom-columns?](#whats-the-deal-with-jsonpath-and-custom-columns)
        * [How do I install a CNI (or anything else)?](#how-do-i-install-a-cni-or-anything-else)
        * [How do I run Docker commands when Docker is removed?](#how-do-i-run-docker-commands-when-docker-is-removed)
        * [How do I diagnose a crashed API Server?](#how-do-i-diagnose-a-crashed-api-server)
        * [How-to: Install Ingress in the KodeKloud playgrounds](#how-to-install-ingress-in-the-kodekloud-playgrounds)
        * [How-to: Install Gateway API in the KodeKloud playgrounds](#how-to-install-gateway-api-in-the-kodekloud-playgrounds)
        * [What is an operator in Kubernetes?](#what-is-an-operator-in-kubernetes)
        * [What's the deal with Certificate Signing Requests?](./docs/certificate-signing-requests.md)
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

# KodeKloud Forums

As of March 1st 2024 we have discontinued use of Slack. Our online forums are now as follows

* [Community Forum](https://community.kodekloud.com/) - Please go here for all technical questions and discussions about our courses. There are sections here related to all courses.
* Discord Server - For general conversation. Joining instructions for this should be provided in our courses. If you can't find it, please ask in the Community Forum. Click [here](./docs/Discord_Troubleshooting_Guide.md) for troublshooting joining the discord server.

# KodeKloud Platform

This section is related to questions about the use of the KodeKloud platform, and our courses on Udemy

### I have a question about payments or subscriptions

For all issues related to this, please contact the dedicated team at support@kodekloud.com

### I cannot access labs from Udemy

In all Udemy courses that come with labs, there is a course slide somewhere near the beginning that instructs you how to enrol in the labs, and also provides a coupon code to use on the payment screen. You do need to first create a free account on https://kodekloud.com/ and you should use the same email address as your Udemy account.
Please also read https://support.kodekloud.com/udemy-students-unable-to-access-labs.

You may find the lab instructions and coupon code on the following course slides

| Slide | Course |
|-------|--------|
|8	|Ansible for the Absolute Beginner - Hands-On - DevOps|
|15	|Docker for the Absolute Beginner - Hands On - DevOps|
|4	|Kubernetes for the Absolute Beginners - Hands-on|
|19	|Kubernetes Certified Application Developer (CKAD) with Tests|
|26	|Certified Kubernetes Administrator (CKA) with Practice Tests|
|12	|Terraform for the Absolute Beginners with Labs|
|9	|Python Basics Course|
|8	|The Ultimate DevOps Bootcamp - 2023|
|5	|Golang for Beginners|
|9	|Linux Foundation Certified Systems Administrator - LFCS|

If you are still having issues, then contact support@kodekloud.com as we cannot resolve subscription issues on public forums like Discord.

# Purchasing Exams Operated by Linux Foundation

To buy any exam run by The Linux Foundation, you need to first sign up with [The Linux Foundation](https://www.linuxfoundation.org/). Once you have an account, known as an LFID, then you can go to their [training portal](https://trainingportal.linuxfoundation.org/) to purchase the exam. For Kubernetes exams, you get two killer.sh sessions included in the purchase. More on this further down this document.

If you are intending to take any Linux Foundation exam (includes all Kubernetes, LFCS and several others), you should create an account ASAP. Once you have an account, you will be notified by email when discounts are available, usually a day or two before they activate - see also [below](#the-certifications-are-so-expensive-what-about-a-discount).

With most of these exams, you have one year from the date of purchase in which to schedule *and* take the exam and this time includes scheduling any free retake that may be offered. You do not have to schedule immediately at time of purchase.

DO NOT LEAVE IT UNTIL THE LAST MINUTE TO SIT THE EXAM!!!

If you do that, and you have only days remaining before the validity expires, what are you going to do if you fail? You have to appear for the exam *and* the retake if you require it before 365 days is up. What if there are are issues with the exam environment (these are not infrequent) which means that you fail to complete, or even start the exam? You should appear for your first attempt *at least* one month before the expiry in case of issues like this. If your exam is credited back to you due to issues like this, then you still have to do this and the free retake if you require it within the one year period.

# Exam Environment

## PSI Bridge

PSI Bridge is the system used to deliver all exams provided by The Linux Foundation, be they performance based or Multiple Choice Question (MCQ). Linux Foundation exams are online only. There is no test center option.

Performance based exams include: CKA, CKAD, CKS, LFCS</br>
Multiple choice exams include: KCNA, PCA

Probably *the* most asked questions!</br></br>This pertains to the new PSI Bridge Proctoring Platform that went live for the Kubernetes exams on 25 June 2022. 

For performance based exams, the bridge provides a Linux XFCE desktop VDI for the exam environment. You may use any of the applications it provides in any way you see fit, however the only useful ones are `Terminal`, `Firefox` and `Mousepad` (for note taking). Firewalls prevent you from browsing anything other than allowed documentation. The terminal application connects to a remote host, thus the File Manager app is of no use, and for the same reason, Mousepad can't be used to edit exam files unless you edit them there, then paste into `vi` (not recommended).

For MCQ exams, the user interface is just multiple choice questions similar to that in KodeKloud.

Many people also ask "Can I use external webcam?", "Can I use bluetooth mouse?" etc. From the point of view of the system check, the PSI software will simply query the operating system. It will expect to find the following devices, and *it doesn't matter* how they are connected (built-in, wired, RF wireless, bluetooth, USB, via docking station, etc., etc.):

* One active monitor
* Mouse
* Keyboard
* Microphone
* Camera

In addition to the Q&A below, you can also watch [our video](https://youtu.be/1fSxM0_dtac) on this subject.

### Students' own notes on the Exam Environment

Download [this PDF](./student-exam-experiences.pdf) of curated student experiences taken from our old Slack channels.

### Can I use an external monitor?

> Yes

...but read the next question too.


### Can I use multiple monitors?

> No

You are permitted to use one *active* monitor. All other monitors must be disabled, and the PSI Secure software will check your display settings to confirm only one monitor is active.

This can be the laptop display, or an externally connected display. If using an external monitor connected to laptop, the laptop display must be disabled:

* **Windows** - This can be done from Display Settings (Windows key + P)
* **Mac** - You must set it up in  [clamshell mode](https://svalt.com/blogs/svalt/76622081-laptop-clamshell-setup), but this will require external camera, keyboard, mouse and possibly microphone too, if the external camera is not fitted with one already - test the mic first!</br>If using an Intel chipset Mac (pre-M1 versions), beware of cooling issues!

Display mirroring (where the laptop and external monitor are showing the same display) is also not permitted.

If using a desktop computer with multiple monitors, disable or disconnect all but your best one.

**TIP**: You are strongly advised *not* to rely on a small laptop screen (like 13 or 14 inch). Your workspace will be extremely tiny, worse if you rely on scaling the font size up. A monitor of higher than HD resolution running at 100% scale and large enough that you can read the text is highly recommended. Anything less than full HD is seriously disadvantageous! On Macs, be sure to adjust display settings to "More Space". See the [image](#what-does-the-environment-look-like) further down this page.

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

It is also quite common for corporate networks to decode HTTPS traffic at the company firewall, log it and re-encode it before your machine gets it. PSI software may detect this and refuse to run, as it would enable the exam content to be logged, and therefore leaked.

Bear in mind that the online PSI compatability check that you run in a browser is _not_ a conclusive check of everything. It tests only _basic_ compatibility. It does not check for example, programs that are not allowed to be operational duing the exam.

See also [launching the exam](https://github.com/fireflycons/tips-for-CKA-CKAD-CKS#launching-the-exam)

### Can I request a break?

> Yes

Press the "Request Break" button at top left of the PSI application, if you need to leave the keyboard for any reason. It can be seen in the [image](#what-does-the-environment-look-like) below.

**This is not recommended as the countdown timer does not stop**! Ensure you've done what you need to do before beginning the exam :wink:.

### How do I remove the nag dialog when pasting into the terminal application?

This should already be turned off (originally it wasn't), however if you do get it, in the terminal application, select `Edit -> Preferences`. Uncheck `Show unsafe paste dialog`.

You can practice this in killer.sh before the exam.

### What are the system requirements for taking the exam?

**IMPORTANT**
* Linux is not supported _except_ for Ubuntu 20.04, 22.04 and 24.04. Beware - some people have had issues getting PSI bridge to run, even on supported distros. This can waste time and cause stress at the start of the exam. Better to use Windows or Mac if you can.
* Intel Mac - Monterey (until 02 Dec 24), Ventura.
* Apple silicon Mac (M1/M2/M3 etc) - Sonoma, Sequoia.
* Windows - Windows 10, 11 64 bit, all editions.

Please see [PSI Bridge Requirements](https://helpdesk.psionline.com/hc/en-gb/articles/4409608794260--PSI-Bridge-FAQ-System-Requirements) and [Exam System Requirements (Linux Foundation)](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-system-requirements-to-take-the-exam)

The PSI document states a minimum screen resolution of 1368x769, but we *really* would not recommend that. See the section on [monitors](#can-i-use-multiple-monitors) above.

See also this [detailed write-up on events for exam day](https://github.com/fireflycons/tips-for-CKA-CKAD-CKS).

### What ID is required?

Most national or state government issued photo ID where the name exactly matches the name you gave when registering for the exam. If your primary ID is in a language that uses non-Latin characters (e.g. Arabic, Greek, Hindi, Russian etc.), then you must provide an additional form of ID that has your name as written in English.

Your ID must not be expired.

* Students have reported that Indian Aadhaar cards are sufficient. We do not have any reports of PAN.
* Drivers License is usually sufficient (definitely works in UK).
* Passport is always sufficient.

Finally, please carefully read [Exam ID requirements](https://docs.linuxfoundation.org/tc-docs/certification/faq-cka-ckad-cks#what-are-the-id-requirements-to-take-the-exam).


### Issues with launching the exam

Please read the [PSI Bridge FAQ](https://helpdesk.psionline.com/hc/en-gb/sections/360013179931-PSI-Bridge-FAQ) BEFORE you appear for the exam so you know what kind of setup issues you may face.

### What happens if there are issues during the exam?

No infrastructure is perfect! Be that KodeKloud labs, killer.sh or the exam environment. There may be issues that cause the exam to slow down or even disconnect in the middle of your session. Some issues are beyond the control of the environment provider (KodeKloud, PSI, etc), and include but probably not limited to:

* Issue with your own broadband provider.
* Issue with some third party network provider on the route between your own broadband provider and PSI's exam environment. This would add latency (lagging) or disconnects.
* The route between your location and the nearest cloud region has many hops or has slow sections (again adds latency). Doesn't matter how fast your own broadband provider is. If the route goes through a slow section, then that is the maximum speed you will attain. Think traffic jam - having a Ferrari won't get you through it any faster!
* Issue within the cloud provider used by the exam platform (AWS, GCP, Azure - don't know which they actually do use).
* Issue with the exam platform.
* Issue with PSI themselves.

The first two and to a certain extent the third are more likely if you live in, or the route crosses countries with poorly maintained infrastructure or political instability. What I'm getting at is it is not *always* PSI's fault! If you are still connected to the proctor, then they will generally try to help but it is not always successful. In the event that your exam finishes incomplete due to technical issues, you must [raise a ticket with Linux Foundation](https://trainingsupport.linuxfoundation.org/) explaining clearly what happened. In most cases they will credit your exam back to you.

**Speedtest**

Many people say "Oh, but I ran speedtest and it said that my speed was (something mega fast)". That's all well and good, but it is only testing the speed between you and some server that is geographically close to you - usually not more than a few hundred miles away. The exam infrastructure might be running in a different country potentially thousands of miles away! Nobody actually knows which cloud provider PSI uses, or exactly where they launch the exam infrastructure, however USA is 99% certain, and it is also very likely they have a mirror in London, since personally I've been fine with all exams I've run living very close to London. As for anywhere else, that's unknown. My broadband is 500 mbps, but if I run a speedtest to West Coast USA from London, I get a tenth of the speed and signifcantly longer ping times and latency measurements!
You need to do `Change server` in speedtest, and run tests for each of the possible locations for the cloud provider regions. Choose a server in a city in each of the following locations

* AWS Each of the four US regions and `eu-west-2` (London). See [here](https://docs.aws.amazon.com/global-infrastructure/latest/regions/aws-regions.html#available-regions).
* Azure - All of the USA regions, and`UK South` (London) - See [here](https://learn.microsoft.com/en-us/azure/reliability/regions-list#azure-regions-list-1)
* GCP - All of the USA reagions and London - See [here](https://cloud.google.com/about/locations)

**Proctors**

Please bear in mind that proctors are *non-technical*. They are very unlikely to be able to resolve an issue.

* Proctors work for PSI - Their primary function is to check you into the exam and ensure you are not cheating.
* They may be able to assist on issues with the PSI Browser itself.
* They cannot assist with issues *inside* the exam environment. The PSI platform is used for exams from many providers, including Linux Foundation and AWS. Such issues are the responsibility of the organization that set the exam, and you have to raise a support ticket with that organization following an environment failure.

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

> 3 *business* days

Expect _at least 3 business days_ for a response. If you raise it on a Friday, you're unlikely to hear back before the following Wednesday. They don't work weekends or US public holidays.

### The certifications are *so* expensive! What about a discount?

Linux Foundation certifications are quite expensive, however Linux Foundation do from time to time offer fairly substantial discounts, sometimes as much as 45%. KodeKloud have no advance notice of when these discounts will occur or how big they will be, however Black Friday weekend is almost certain and usually a large one, and other holiday weekends in the US calendar are not uncommon. You need to check their [website](https://training.linuxfoundation.org/) frequently.

If you have created a [Linux Foundation](https://www.linuxfoundation.org/) account - which you need to have in order to purchase exams - they will normally email you when a promo is going to happen. So, go create one now!

## Performance Based Exams

If you are doing a Multiple Choice Question exam, skip this section.

Performance based exams are provided in a virtual desktop (VDI) within the PSI Bridge software. This VDI is a Linux XFCE desktop running on top of Ubuntu. Kubernetes and LFCS fall in this category.

### Can I use my own bookmarks?

> No

Because you cannot run your own browser. The only software that may be running on your desktop at exam time is the PSI software. Each question has several relevant links into the Kubernetes documentation. Clicking these links opens tabs in Firefox within the exam environment. You can visit any of the allowed documentation using the provided Firefox.</br>You may open multiple tabs in Firefox, however a question may state that you can only open one additional tab on a particular topic.<br/>You may use the `man` command in the terminal to get help on Linux commands.

### Can I open multiple terminal sessions?

> Yes

Either multiple instances of the terminal emulator app, multiple tabs within the terminal emulator, or both. We would encourage you to do so. This is useful when editing manifests. Have the manifest open in `vi` in one terminal, and a command prompt in the other. Edit the YAML and save without exiting (`:w`). In the other terminal, apply. Repeat until the bugs in the YAML are out.

### How do I copy/paste in the exam terminal?

Note that the exam gives you an option to see the copy/paste functionality as part of the pre-start tour. You should read this and ensure it aligns with the following. *Remember that what it says there is what will happen*.

The exam terminals are Linux terminals and follow the rules for Linux terminals. You should be able to select text with the mouse.

* Right clicking in the terminal window will give a menu with copy/paste on it.
* `CTRL+SHIFT+C` to copy using the keyboard
* `CTRL+SHIFT+V` to paste to the termninal

You need to use `SHIFT` in the terminal window, because the regualr CTRL sequences have special meaning to terminals. In GUI applications like mousepad, copy/pate operations are as you would expect.

### Can I paste settings for vi, aliases etc from my notepad?

> No

The only software that may be running is the PSI software, therefore you must memorize such things and enter them up manually at the beginning of the exam.

### Can I install packages or download *anything* to the exam terminal?

> Yes and No

You may install additional packages if they are part of the operating system distribution. What this means is that you may use the Linux package manager to install anything that is available by default on the terminal without the addition of other `apt` (or `yum/dnf` on CentOS terminals) package repos, unless directed by a question to add one. You may not download third party packages using curl, wget, cloning from Github etc. unless directed by a question.

The Linux Foundation also says this, quoted from a question raised on the training support portal

> Curl and wget commands are allowed during the exam. Unauthorized sites are blocked, i.e. they will not load, so you will not receive a penalty.

What this means that there is a firewall between the exam terminal and the Internet which will *actively prevent* you from accessing unauthorized sites.

It is therefore also possible in Kubernetes exams to directly download YAML fragments to files on the exam terminal by right-clicking the copy link and pasting the copied URL to a [wget or curl command](https://discord.com/channels/1197109182172770304/1222924937040232592/1303030265530155089) (link to KodeKloud discord), thus eliminating copy/paste of entire blocks of YAML.

See also the third bullet point [here](https://docs.linuxfoundation.org/tc-docs/certification/lf-handbook2/exam-rules-and-policies#policy-on-tools-and-resources-allowed-during-exam).

### Will I be failed if I click a link that is outside of allowed docs?

Pretty much the same as the previous question. The Linux Foundation says:

> Keep in mind that the search function at kubernetes.io/docs may sometimes point to results outside the documentation (e.g. discussion forum) - you will not be able to open URLs that are not nested under kubernetes.io/docs domain.

This applies to all allowed documentation based on the exam you are taking.

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

## Kubernetes Certifications

This section applies to performance based Kubernetes exams only, i.e. CKA, CKAD and CKS. If you are doing KCNA, skip this section.

## About the Kubernetes exam environments

All 3 exams use multiple clusters, usually one cluster per question. The good news is that if you break a cluster it will affect the scoring of that question only. The bad news is that you must first `ssh` to the control plane node of the cluster for the question. The SSH command required is given in the question pane and can be copied and pasted to the terminal.

The fact that you must SSH to a different node for every question means that you cannot customise `vi` editor once and use for the whole exam. You would have to repeat that customisation for *every* question which would lose too much time! The defaults they have are sufficient for YAML editing.

On all terminals, the `k` alias and `kubectl` autocomplete is pre-configured.

### What are the similarities/differences between CKA and CKAD?

Please see [here](./docs/cka-vs-ckad.md)

### How many killer.sh sessions do I get?

> 2

Please see [killer.sh](./docs/killer-sh.md) FAQ page.

### How does killer.sh compare to the real thing?

> Very closely

Please see [killer.sh](./docs/killer-sh.md) FAQ page.

### How do I get some SERIOUS practice?

If you have a KodeKloud subscription which you will have if you did the course via KK platform rather than Udemy, you can attempt our Ultimate Mock Exam series. These are much harder than the real exam, and likely harder than Killer, with more questions than Killer across the series. Some questions will cover tasks that you will not be expected to perform in the real exam, and possibly involving resources and techniques not covered in the courses. These are to test your skills of information gathering and problem solving that you will face in the real world should you land a job doing Kubernetes.<br/>Try to stick to the [permitted documentation](https://docs.linuxfoundation.org/tc-docs/certification/certification-resources-allowed#certified-kubernetes-administrator-cka-and-certified-kubernetes-application-developer-ckad) and not use Google, but there are one or two tasks that would require you to break this rule (e.g. viewing the [etcd documentation](https://etcd.io/docs/v3.5/)). You can be sure these tasks _won't_ show up in the real exam.

* [Kubernetes Challenges](https://kodekloud.com/courses/kubernetes-challenges/) - FREE course. These can be done by CKA or CKAD students, but challenge 2 requires some specific knowledge taught only in CKA.
* [Ultimate CKA Mocks](https://kodekloud.com/courses/ultimate-certified-kubernetes-administrator-cka-mock-exam/) - Available on standard KodeKloud subscription.
* [Ultimate CKAD Mocks](https://kodekloud.com/courses/ultimate-certified-kubernetes-application-developer-ckad-mock-exam-series/) - Available on standard KodeKloud subscription.
* [CKS Challenges](https://kodekloud.com/courses/cks-challenges/) - FREE course.

### How do I upgrade a cluster?

Specifically, the question asks to upgrade to version X of Kubernetes, but I can't find the right version of the packages.

See the dedicated [upgrade FAQ](./docs/cluster-upgrades.md)

### How do I backup etcd?

See the dedicated [etcd FAQ](./docs/etcd-faq.md)

### How do I restore etcd?

See the dedicated [etcd FAQ](./docs/etcd-faq.md)

### What's the deal with jsonpath and custom-columns?

See the dedicated [jsonpath FAQ](./docs/jsonpath.md)

### How do I install a CNI (or anything else)?

You will *not* be expected to memorize download locations for third party tools you may have downloaded in course labs. If you are required to install any software or 3rd party Kubernetes applications, then the question will tell you where to obtain the files/packages you need.

Note that for e.g. cluster upgrades, then `apt` package manager should work exactly as you have practiced in labs.

### How do I run Docker commands when Docker is removed?

For questions specifically related to Docker, then the docker command will be present.

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

See [this guide](./docs/how-tos/howto-install-ingress-on-kk-playground.md).

### How-to: Install Gateway API in the KodeKloud playgrounds

See [this guide](./docs/how-tos/howto-install-gateway-api-on-kk-playground.md).

### What is an operator in Kubernetes?

See [this guide](./docs/kube-operators/README.md)

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

Should a response from Linux Foundation contradict anything on this page, please reach out to a member of the support team in Discord. Thanks!

KodeKloud Team.

