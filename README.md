# QubesOS-Scripts
My scripts for setting up QubesOS. 

Running these scripts should be very straight forward. For the default Fedora template, run fedora.sh to trim it down first. For Debian templates, run kicksecure.sh to trim them down and convert them to KickSecure. Note that there are 2 different kicksecure.sh, one for the minimal template, and one for the normal one.

After you are done running those scripts, any other script can be used in a different template based on those trimmed down templates to create their respective virtual machines.

I have a script to create a Brave VM based on the normal KickSecure and Fedora templates. The idea behind this is that you would want to use a disposable Brave VM for web browsing most of the time, and have it seperated from your AppVM. If you try to visit a link inside of an AppVM without a browser, qubes will launch a browser inside of a disposable VM for you. Of course, for VMs where you want the browser to stay persistent, you can just base it on the Brave template instead.

If you want to install Flatpak packages, install them inside of an AppVM as a **user Flatpak** and enable the update-user-flatpaks.service as a **user** systemd service for automatic updates.