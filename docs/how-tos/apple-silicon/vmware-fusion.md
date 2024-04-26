# How-To: Install VMware Fusion

VMware Fusion is a type-2 hypervisor for Apple Silicon computers. This allows you to run a variety of virtual machines on your laptop, and is one alternative to running VirtualBox.

1. In order to download the player, you must first create an account with VMware. Go [here](https://customerconnect.vmware.com/en/evalcenter?p=fusion-player-personal-13) and click on **Create an Account** to do this.
1. Following completion of account creation, log into the site with your new credentials, then return to the [Fusion page](https://customerconnect.vmware.com/en/evalcenter?p=fusion-player-personal-13) and click on **License & Download**.
1. Make a note of the license key.
1. Click on the **Manually Download** button. This will download a `.dmg` (installer disk) file.
1. Click on the `.dmg` file to run the installer and follow the instructions.
1. At the end of the installation, you will be prompted for the license key you obtained in step 3 above.
1. It will now check for updates and probably find some which you should apply.


Now let's install Vagrant and configure it to work with VMware

1. Go to the [downloads page](https://developer.hashicorp.com/vagrant/install).
1. Follow the instructions. It is easiest to install via homebrew, however if you want to do it manually, you should download the ARM64 version.
1. Install the VMware plugin for vagrant
   ```
   vagrant plugin install vagrant-vmware-desktop
   ```

1. Next, install the Vagrant VMware utility
    1. Go [here](https://developer.hashicorp.com/vagrant/install/vmware).
    1. Download the ARM64 version for macOS which is another `.dmg` installer.
    1. Click on the `.dmg` file and then on the package icon in the dialog that follows.
    1. Follow the instructions.