# How-To: Package Management on Windows

The DevOps way to install software on your system should be something that can be run from the command prompt,  scripted and used in automation.

* On Linux, we have the standard package managers like `yum`, `dnf` and `apt`.
* On MacOS, we have (with a litte extra work to install it) HomeBrew.
* What about Windows?

When we install software, we want it ready to use such that if you are at the command prompt, you can type its name , e.g. `terraform` and expect it to work. Normally for this to happen on Windows, it is necessary to download a setup program which runs as a GUI app and requires you to press buttons and make selections. This is not scriptable.

Fortunately, there is a package manager for Windows in the vein of MacOS's HomeBrew which is quite straight forward to install, and once you have installed it, then installing other software like `terraform` or `kubectl` becomes much simpler. This package manager is called `chocolatey`

## Installing Chocolatey

1. Go to https://chocolatey.org/install
1. Select `Individual` for the install method
1. Follow the instructions presented on that page to install

## Using Chocolatey

### Installing Packages

Note that when installing or upgrading packages, you must begin by opening either Windows CMD or PowerShell via "Run as administrator". Installing software requires admin rights.

1. Search for the package you want by going to https://community.chocolatey.org/packages
1. Type the name of the software you require, e.g. `terraform` in the seach box
1. Copy the install command e.g. `choco install terraform`
1. Paste that to the command prompt and run it.
1. Close the admin command prompt and open a regular one. You can now run the command, e.g.

    ```
    C:\Users\yourname>terraform version
    Terraform v1.12.2
    on windows_amd64

    C:\Users\yourname>
    ```

### Listing Installed Packages

To see what packages you have installed and their versions, simply run the following in a regular CMD or PowerShell prompt

```
choco list
```

### Upgrading Packages

To upgrade a package to the latest version first open a prompt "As Administrator", list your packages as above, then using the name of the package, run e.g.

```
choco upgrade terraform
```


