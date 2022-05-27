# QubesOS-Scripts
My scripts for setting up QubesOS. 

Running these scripts should be very straight forward. For the default Fedora template, run fedora.sh to trim it down first. For Debian templates, run kicksecure.sh to trim them down and convert them to KickSecure. Note that there are 2 different kicksecure.sh, one for the minimal template, and one for the normal one.

After you are done running those scripts, any other script can be used in a different template based on those trimmed down templates to create their respective virtual machines.

I have a script to create a Brave VM based on the normal KickSecure and Fedora templates. The idea behind this is that you would want to use a disposable Brave VM for web browsing most of the time, and have it seperated from your AppVM. If you try to visit a link inside of an AppVM without a browser, qubes will launch a browser inside of a disposable VM for you. Of course, for VMs where you want the browser to stay persistent, you can just base it on the Brave template instead.

If you want to install Flatpak packages, install them inside of an AppVM as a **user Flatpak** and enable the update-user-flatpaks.service as a **user** systemd service for automatic updates.

It is recommended that you follow the docs [here](https://www.qubes-os.org/doc/vm-sudo/#replacing-passwordless-root-access-with-dom0-user-prompt) to make a prompt for root access on non-minimal VMs. dom0.sh already takes care dom dom0 so you only need to worry about the guests.

# Notes
1. Kicksecure, while having more security mitigation, takes significantly longer than Fedora to launch and generally runs slower.
2. Currently, launching Flatpak apps from the appmenu does not work on KickSecure. I have not been able to find the culprit, so any help would be greatly appreciated.
3. My personal recommendation is use KickSecure for system VMs like sys-net and sys-usb. For normal apps, especially Flatpaks, just use Fedora instead. Of course, the exception to this rule would be when you can only get official binaries for Debian, like with Signal and Element for example. 
