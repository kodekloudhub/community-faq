# Upgrading Clusters With Kubeadm

This FAQ is here to help you with problems using kubeadm to upgrade Kubernetes clusters.

Back in August 2023, the Kubernetes Project announced that the Google-hosted repositories that have been used to do kubeadm installs and upgrades were going away, to be replaced by community hosted repositories not hosted by Google.  This changes the way that we will do kubeadm installs, and it also changes how we do upgrades. This FAQ covers how it changes the way we do upgrades.

## How The New Repos Work

Under the old system we had one giant repo that covered all versions going back a number of years. Once you configured your package repository for that one monster repo, you were set, and didn't need to worry about configuring anything again -- when new versions of kubeadm and other binaries came out, they were added to that repo.

[The new system is different](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/). Each minor version (e.g., 1.27, 1.28, 1.29) has its own repo (going back to 1.24), and if you want to install binaries from that family of binaries, you need to configure your package manager to include the repo for that binary version.  In our Kubernetes certification courses, we use Ubuntu systems, which use the `apt` package manager.  To support a Kubernetes such as 1.29, you need to:

1. Find the right file under `/etc/apt` on the system you need to upgrade.  In the Kubernetes docs and in our labs, that file is `/etc/apt/sources.list.d/kubernetes.list`, but it can be any other file name under `/etc/apt/sources.list.d`, or even in `/etc/apt/sources.list`, although we don't recommend that.

1. You need to edit that file to support our desired version. The easiest thing to do is to look for a line that starts with `deb`, and edit the version number to what you need to install. If you see a line like:

    ```text
    deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /
    ```

    then you need to edit to be:

    ```text
    deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /
    ```

1. Run `sudo apt update`
1. Now run `sudo apt-cache madison kubeadm` , and you will see 1.29 versions of the `kubeadm` package:

    ```text
    root@controlplane:/home/ubuntu# apt-cache madison kubeadm
    kubeadm | 1.29.2-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
    kubeadm | 1.29.1-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
    kubeadm | 1.29.0-1.1 | https://pkgs.k8s.io/core:/stable:/v1.29/deb  Packages
    111
    ```

    To install 1.29.0, you'll use the 1.29.0-1.1 version of the kubeadm package.



1. Install kubeadm, kubectl and kubelet with a command like

    ```bash
    sudo apt install kubeadm=1.29.0-1.1 kubelet=1.29.0-1.1 kubectl=1.29.0-1.1
    ```

1. Run `sudo kubeadm upgrade apply v1.29.0` on your (first) controlplane node, and `sudo kubeadm upgrade node` on the worker nodes in your cluster.