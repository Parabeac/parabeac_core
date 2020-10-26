# Parabeac-Core setup for Windows
To get started with using or developing the source code on Windows some configuration is required. This document is meant to help users with that.

## Setup using WSL 2

One of the ways we can get starting with Parabeac-Core on Windows is by utilizing the Windows Subset for Linux version 2. This allows Windows 10 users to utilize the most of Linux and to combine this with the Windows workflow. This prevents overhead that comes with solutions like a VM or dual boot. To learn more about WSL 2 you can visit [this page](https://docs.microsoft.com/en-us/windows/wsl/about).

## Index
- [Requirements](#Requirements)
- [Installing WSL 2](#Installing-WSL-2)
- [Ubuntu setup](#Ubuntu-setup)
- [Flutter install](#Flutter-install)
- [Cloning Parabeac-Core](#Cloning-Parabeac-Core)
- [(Optional) Fix NPM](#(Optional)-Fix-NPM)
- [(Optional) Install VS-Code and WSL 2 extension](#(Optional)-Install-VS-Code-and-WSL-2-extension)
- [(Optional) Android emulation](#(Optional)-Android-emulation)

### Requirements
Although WSL is supported on most Windows installations, there are still some requirements that need to be met before we can continue:
-   For x64:
    - At least Windows version 1903 with at least build 18362

Although WSL 2 is supported on ARM64 we'll only focus on x64.

### Installing WSL 2
To summarize the first step, we first need to activate WSL 1 and then update it to version 2. Follow these steps:
1.  First we need to enable WSL. Open up an elevated PowerShell instance and execute the following command: `dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`

2.  Next we need to enable the virtual machine platform. Execute this PowerShell command: `dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`

3. **Now, restart your device!** This is required to finish the installation of WSL.

4. After restarting, download and install the [WSL2 Linux kernel update](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi).

5. Execute this PowerShell command: `wsl --set-default-version 2` This makes WSL 2 the default version for further usage. This may take some minutes.

6. WSL 2 is now enabled. Next, we need a Linux distro. You could choose some of your choices from the Windows Store, but for this guide, we'll use Ubuntu, [download this distro](https://www.microsoft.com/nl-nl/p/ubuntu/9nblggh4msv6).


### Ubuntu setup
Next, ubuntu requires some setup.
1. Boot up Ubuntu. It will install some things, let it finish
2. Next choose a username, password and reconfirm your password.
3. Lastly let's update our distro. Execute the following commands: `sudo apt-get upgrade` and `sudo apt-get update`

### Flutter install
Parabeac-core is built in Dart and generates Flutter apps, which make use of Dart and the Android SDK. The Android SDK itself requires the Java JDK. Let's install all of this.
1. First let's make a download folder: `mkdir downloads` and move into it: `cd downloads`. 

2. Then download the OpenJDK 8. Recommended is visiting [AdoptOpenJDK.net](https://adoptopenjdk.net/releases.html?variant=openjdk8&jvmVariant=hotspot) and copying the download url by right-clicking the **JDK** `.tar.gz` download button and then copy. Then type `sudo wget [url]`. You can past the url you copied by right-clicking in the console and execute it.

3. Extract the JDK: `sudo tar -xvzf [downloadedJdk.tar.gz]` By typing `O` and then pressing tab you can autocomplete the name of the downloaded file.

4. Next, lets move the JDK to a more permanent place: `sudo mv [extractionName] /opt/openJDK`. extractionName is the folder name to where the downloaded file is extracted. You can find this with the `ls` command.

5. Next up: the Android SDK. Google provides a command line tool to download android development software, so we'll make use of that. The download url can be found on the [Android Developers site](https://developer.android.com/studio). Scroll to the bottom to "Command line tools only", click the link of Linux, read and accept the terms and copy the url by right-clicking the download button and copy. Then back in Ubuntu execute the following: `sudo wget [downloadUrl]`.

6. We got another zip, but this time a `.zip` file. For this, we need a new package: `sudo apt-get install unzip`.

7. Then extract the download: `sudo unzip [downloadedFile.zip]`.

8. And move it to a permanent place: `sudo mkdir --parents ~/Android/Sdk/cmdline-tools; sudo mv tools ~/Android/Sdk/cmdline-tools/tools`.

9. To make the JDK and android command line tools available throughout the distro we'll need to make it findable. We can do this by adding a few lines to the `.bashrc` file. Open the file: `sudo nano ~/.bashrc`.

10. Add the following lines to the file:
```bashrc
export DART=/home/roel/snap/flutter/common/flutter/bin
export ANDROID_SDK_ROOT=/home/[your selected ubuntu username]/Android/Sdk
export JAVA_HOME=/opt/openJDK
export PATH=$PATH:$ANDROID_SDK_ROOT/build-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/emulators
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/tools/bin
export PATH=$PATH:$DART
```

Exit out of nano with `CTRL-x & CTRL-y`.

11. At this point we'd be required to restart our Ubuntu machine. But since we're use WSL 2 we can just restart our distro instance. Close the app, and then re-open it.

If everything went correctly we now can use the command line tools.
Next, we need the build tools. The choice we make here will determine the Android version the Parabeac-core Flutter app will target. If you choose to debug using the emulator we'll install later on, you can follow the following instructions. But if you want to do this on your own device you'll need to select an API level that supports your device. You can do that on [this page](https://developer.android.com/studio/releases/platforms). You'll need to replace the API version numbers we'll use in the following commands with the one your device supports. You can look up the versions with `sdkmanager --list`.

13. For our commands to succeed we need to give write access to the folder, execute `sudo chmod -R a+w ~/Android/Sdk`.

14. Now install the SDK and build-tools: `sdkmanager "platforms;android-30" "build-tools;30.0.2"` Optionally replace the version number with your API level.

15. And for debugging, later on, we need the platform-tools: `sdkmanager "platform-tools"`

Now, time for Flutter. Flutter uses the snap package manager, sadly this doesn't work in WSL 2 out of the box because of an issue with systemd at time of writing. So, let's fix it first!

16. Move back to your home: `cd ~/` and make a repos folder `mkdir repos`.

17. Clone our fix: `git clone https://github.com/DamionGans/ubuntu-wsl2-systemd-script.git` and move into it `cd ubuntu-wsl2-systemd-script/`.

18. Run the script: `sudo bash ubuntu-wsl2-systemd-script.sh`.

19. Lastly, run these scripts `cmd.exe /C setx WSLENV BASH_ENV/u` and `cmd.exe /C setx BASH_ENV /etc/bash.bashrc`.

20. Now we need to restart Ubuntu by closing and re-opening the app.

21. Finally, test if snap works: `snap --version` This should return the version numbers of the snap components. If it hangs it means snap isn't yet working correctly.

22. Now, install Flutter: `sudo snap install flutter --classic`. (This could take some time!).

23. After that, initialize Flutter: `flutter doctor`(This again could take some time!).

24. If this went correctly Flutter should state that you need to accept the Android licenses, so do that: `flutter doctor --android-licenses` Read the terms and accept each of them by entering `y`.

### Cloning Parabeac-core
With all of this done, we can now get started with Parabeac-core.
Let's get started:

1. Move back into your repo folder: `cd ~/repos`.

2. Clone Parabeac-Core: `git clone --recurse-submodules https://github.com/Parabeac/Parabeac-Core.git`.

3. Move into Parabeac-Core: `cd Parabeac-core` and restore packages `flutter pub get`.

4. Parabeac makes use of Node.js to restore NPM packages during a project build. So let's install Node: `curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -` and then `sudo apt-get install -y nodejs`.

And there we have it. Congratulations! we've installed:
- Ubuntu
- WSL 2
- Java OpenJDK 8
- Android command line tools
- Android build tools
- Android platform SDK
- Android platform tools
- Flutter
- Dart
- Node.js

And now have a Parabeac-Core repo ready for usage/development!

### (Optional) Fix NPM
When you run Parabeac to generate a project it tries to restore NPM packages. However, an error could occur. This probably because you have Node installed both on Windows and WSL 2. A solution: remove the location of the Windows installation from your Windows path.

1. Open Windows search and then open "Edit the system environment variables".

2. Click on "Environment variables".

3. Select the "Path" variable under user variables.

4. Check if there's a reference to node or npm. Try temporarily removing this.

5. Repeat from step 3, but then under system variables.

6. Restart the Ubuntu distro.


### (Optional) Install VS-Code and WSL 2 extension
A recommended code editor is Visual Studio Code. This program provides an extension to link the Windows VSCode installation with code from WSL 2.

1. [Download and install VSCode.](https://code.visualstudio.com/)

2. Next, download and install the [Remote - WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) extension.

3. After this is done, go back to Ubuntu. Move into your repo `cd ~/repos/Parabeac-core` and open VSCode by executing: `code .` This opens VSCode in Windows, with a link to WSL 2. You can now program in Windows and commit in WSL.

### (Optional) Android emulation
Parabeac generates a Flutter project for Android. Now, we could build this project to an APK and push it to a device. Or we could emulate it.
By installing Android Studio with the emulator component and some ADB tricks we can emulate our generated project which resides in WSL 2 in an Android Studio emulator which runs on Windows!

1. Let's first download and install [Android Studio](https://developer.android.com/studio) for Windows. Make sure you select the emulator component during installation!

2. Start Android studio but stop at the project selection screen. Here we go into `Configure -> AVD Manager`.

3. There should be a default emulator already present, named `Pixel_3a_API_30_x86`. This could differ slightly in the device name and API level. Start this emulator.

4. Move with a Windows command line into the Android platform-tools folder which was installed by Android Studio: `cd %LocalAppData%/Android/Sdk/platform-tools`.

5. Next, kill any running adb instances: `adb kill-server` and then start it again `adb -a nodaemon server start` It will ask to define the firewall rule. Make sure to select **Public** here, since the network adapter to WSL 2 belongs in the public profile!

6. Go back to the Ubuntu terminal, we need to set some env variables: `export WSL_HOST=$(tail -1 /etc/resolv.conf | cut -d' ' -f2)` and `export ADB_SERVER_SOCKET=tcp:$WSL_HOST:5037`.

7. Install socat: `sudo apt-get install socat` and then use socat to relay WSL2 adb requests to Windows: `socat -d -d TCP-LISTEN:5037,reuseaddr,fork TCP:$(cat /etc/resolv.conf | tail -n1 | cut -d " " -f 2):5037`.

8. Open up a new instance of the Ubuntu terminal. Now, if you search for adb devices, the emulator should pop up there `adb devices`.

With this, you can now push the Flutter project to your emulator. This should be confirmed by the doctor tool: `flutter doctor`.
