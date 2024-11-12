# QubesOS-Scripts

[![ShellCheck](https://github.com/TommyTran732/QubesOS-Scripts/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/TommyTran732/QubesOS-Scripts/actions/workflows/shellcheck.yml)

My scripts for setting up QubesOS. 

Running these scripts should be very straight forward. For the default Fedora template, run fedora-gnome.sh to trim it down first.

After you are done running those scripts, any other script can be used in a different template based on those trimmed down templates to create their respective virtual machines.

If you want to install Flatpak packages, install them inside of an AppVM as a **user Flatpak** and enable the update-user-flatpaks.service as a **user** systemd service for automatic updates.

It is recommended that you follow the docs [here](https://www.qubes-os.org/doc/vm-sudo/#replacing-passwordless-root-access-with-dom0-user-prompt) to make a prompt for root access on non-minimal VMs. dom0.sh already takes care dom dom0 so you only need to worry about the guests.

## Laptop Recommendations

Qubes AEM currently still requires legacy boot. Officially, the last generation of Intel CPUs with VBIOS to support legacy boot Coffee Lake. However, I have found that certain Comet Lake Thinkpads still have legacy support.

I recommend that you look though [Lenovo's BIOS simulator](https://download.lenovo.com/bsco/index.html#/) to find a suitable Comet Lake Thinkpad. These will have the longest remaining support lifecycle. Personally, I use a Thinkpad T14 gen 1.

## Lenovo ePrivacy

Lenovo ePrivacy can be controlled through `/proc/acpi/ibm/lcdshadow`. I use the following shortcuts:

- F5: `sudo bash -c 'echo 1 > /proc/acpi/ibm/lcdshadow'`
- F6: `sudo bash -c 'echo 0 > /proc/acpi/ibm/lcdshadow'`