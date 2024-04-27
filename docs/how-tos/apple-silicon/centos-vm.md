# How-To: Run CentOS Virtual Machine on Apple Silicon

Whilst there *is* a CentOS offering for Macs, it's buggy therefore we are going to install an alternative [distro](../../linux-distro.md) that is 100% compatible called Rocky Linux. All CentOS commands found in the courses should also work on this distro.

We will be using VMware Fusion as the hypervisor instead of VirtualBox which does not work on Apple Silicon Macs.

1. Ensure you have installed and configured VMware fusion and Vagrant according to [these instructions](./vmware-fusion.md).
1. Open your terminal application and create a directory to work in.
1. Run the following command to create a `Vagrantfile`
    ```
    vagrant init gyptazy/rocky9.3-arm64
    ```

    This will create `Vagrantfile` in the current directory to spin up a virtual machine with default settings, and a machine name of `default`.
1. If you want to adjust settings like CPU or memory, then you can apply the settings as directed by the course videos to your `Vagrantfile`.
1. Start the VM
    ```
    vagrant up --provider vmware_desktop
    ```
1. Connect to the VM
    ```
    vagrant ssh default
    ```

    If you changed the machine name in the `Vagrantfile` then use that name instead of `default`.
1. Deleting the VM

    In the same directory where you ran `vagrant up`, run the following
    ```
    vagrant destroy -f
    ```
