# Parabeac-Core setup for Windows
To get starting with using or developing the source code on Windows some configuration is required. This document is ment to help users with that.

## Setup using WSL 2
One of the ways we can get starting with Parabeac-Core on Windows is by utilizing the Windows Subset for Linux version 2. This allows Windows 10 users to utilize most of the linux and combining this with the Windows workflow. This prevents overhead that comes with solutions like a VM or dualboot. To learn more about WSL 2 you can visit [this page](https://docs.microsoft.com/en-us/windows/wsl/about).

### Requirements
Altough WSL is supported on most Windows installations, there are still some requirements that need to be met before we can continue:
-   For x64:
    - At least Windows version 1903 with at least build 18362

Altough WSL 2 is supported on ARM64 we'll only focus on x64.

### Installing WSL 2
To summerize the first step, we first need to activate WSL 1 and then update it to version 2. Follow these steps:
1.  First we need to enable WSL. Open up an elevated PowerShell instance and execute the following command: `dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`

2.  Next we need to enable the virtual machine platform. Execute this PowerShell command: `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`

3. **Now, restart your device!** This is required to finish the installation of WSL.

4. After restarting, download and install the [WSL2 linux kernel update](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi).

5. Execute this PowerShell command: `wsl --set-default-version 2` This makes WSL 2 the default version for further usage. This may take some minutes.

6. WSL 2 is now enabled. Next we need a linux distro. You could choose some of your choice from the Windows Store, but for this guide we'll use the Ubuntu, [download this distro](https://www.microsoft.com/nl-nl/p/ubuntu/9nblggh4msv6).


### Ubunutu setup
Next, ubunutu requires some setup.
1. Boot up Ubuntu. It will install some things, let it finish
2. Next choose an username, password and reconfirm your password.
3. Lastly let's update our distro. Execute the following commands: `sudo apt-get upgrade` and `sudo apt-get update`