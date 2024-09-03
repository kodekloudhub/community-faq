# Generic Vagrant Template

This is a generic template for building cross-platform Vagrant VM builds. It is intended to be copied to a specific project, then edited there for that project's requirements.

It should be very simple affair to customize this for a given project and more or less limited to

1. Define the network type by editing [NETWORK_SETTINGS](./Vagrantfile#L9).

    | Property          | Required?      | Value                                                                                                       |
    |-------------------|----------------|-------------------------------------------------------------------------------------------------------------|
    | `network_type`    | yes            | `NAT` or `BRIDGE`. `BRIDGE` is useful for kube deployments as it's not necessary to port forward nodeports. |
    | `private_network` | Only for `NAT` | Prefix of private network to run inside the hypervisor. The default is known to work with all 3 platforms.  |
    | `ip_start`        | Only for `NAT` | IP of first VM on private network. Subsequent VMs will have contiguous IPs.                                 |


1. Define the VMs required by editing the [VIRTUAL_MACHINES](./Vagrantfile#L16) list and setting the properties for each machine in the list.


    | Property   | Required? | Value                                                                                                                                   |
    |------------|-----------|-----------------------------------------------------------------------------------------------------------------------------------------|
    | `name`     | yes       | Name for the VM. Also sets the VM's hostname.                                                                                           |
    | `cpu`      | yes       | Number of vCPU to add to guest.                                                                                                         |
    | `memory`   | yes       | Amount of RAM in MB. Total of all VMs must not exceed host system RAM minus 2GB, or an error will be raised.                            |
    | `box`      | yes       | OS to install, either `Hypervisor.centos` or `Hypervisor.ubuntu`                                                                        |
    | `packages` | no        | Optional list of extra packages to be installed via `yum` or `apt` as appropriate. All VMs will have `jq` and `yq` installed by default. |
    | `ports`    | no        | Optional list of port forwards in the form `<host-port>:<guest-port>`. SSH (22) is automatically forwarded. Ignored for BRIDGE network. |

1. Additional customizations such as shell provision steps can be added inside the [Hypervisor block](./Vagrantfile#L45-L48), using Hypervisor class's methods:

    * `provision_script`

        Run the given script which should be placed in the [linux](./linux/) subdirectory and committed to the target project's repo. The shell script can be passed optional arguments. Note that the same script will be run on *all* guests, so ensure it is [distro aware](./linux/package_install.sh#L10-L13) and idempotent. Host name should be set already as long as the script comes after `hv.deploy` so that could be used in a `case` block.

        ```ruby
        hv.provision_script [arg1 , arg2, ...argn,] script: "my_script.sh"
        ```
