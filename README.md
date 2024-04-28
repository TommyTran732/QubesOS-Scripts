# QubesOS-Scripts
My scripts for setting up QubesOS. 

Running these scripts should be very straight forward. For the default Fedora template, run fedora-gnome.sh to trim it down first.

After you are done running those scripts, any other script can be used in a different template based on those trimmed down templates to create their respective virtual machines.

If you want to install Flatpak packages, install them inside of an AppVM as a **user Flatpak** and enable the update-user-flatpaks.service as a **user** systemd service for automatic updates.

It is recommended that you follow the docs [here](https://www.qubes-os.org/doc/vm-sudo/#replacing-passwordless-root-access-with-dom0-user-prompt) to make a prompt for root access on non-minimal VMs. dom0.sh already takes care dom dom0 so you only need to worry about the guests.