# Generic Vagrant Template

This is a generic template for building cross-platform Vagrant VM builds. It is intended to be copied to a specific project, then edited there for that project's requirements.

It should be very simple affair to customize this for a given project and more or less limited to

1. Define the network type by editing [NETWORK_SETTINGS](./Vagrantfile#L9).
    * `NAT` - run VMs in a private network with the given [IP prefix](./Vagrantfile#L11) (the default is known to work with all 3 platforms) and [IP of the first machine](./Vagrantfile#L12) in the VM list. Subsequent machines will have contiguous IP addresses.
    * `BRIDGE` - run VMs on host machine's LAN. Useful for Kubernetes deployments as it's not necessary to port-forward nodeports.
1. Define the VMs required by editing the [VIRTUAL_MACHINES](./Vagrantfile#L16) list and setting the properties for each machine in the list.
    * All VMs will have `jq` and `yq` installed by default. Additional packages can be added by populating the [packages](./Vagrantfile#L22) list for each VM. Package names are specific to the VM's package manager (CentOS - `yum`, Ubuntu - `apt`).
1. Additional customizations such as port-forwards or shell provision steps can be added inside the [Hypervisor block](./Vagrantfile#L42-L45), using Hypervisor class's methods:

    * `port_forward`

        Forward 8080 on host to 80 on guest

        ```ruby
        hv.port_forward host: 8080, guest: 80
        ```

        Note that the SSH port is automatically forwarded by Vagrant so you don't have to.

    * `provision_script`

        Run the given script which should be placed in the [linux](./linux/) subdirectory in the guest. The shell script can be passed optional arguments. Note that the same script will be run on *all* guests, so ensure it is [distro aware](./linux/setup_host.sh#L11-L13) and idempotent. Host name should be set already as long as the script comes after `hv.deploy` so that can also be switched on

        ```ruby
        hv.provision_script [arg1 , arg2, ...argn,] script: "my_script.sh"
        ```
