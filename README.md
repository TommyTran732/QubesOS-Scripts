# QubesOS-Scripts

[![ShellCheck](https://github.com/TommyTran732/QubesOS-Scripts/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/TommyTran732/QubesOS-Scripts/actions/workflows/shellcheck.yml)

My scripts for setting up QubesOS. 

For each OS, run the script associated with them to trim down the templates provided by Qubes first. For example, for Fedora, run the `fedora-gnome.sh` script. After the base templates have been trimmed down, run other scripts in templates based on them to create their respective TemplateVMs.

If you want to install Flatpak packages, install them inside of an AppVM as a **user Flatpak** and enable the update-user-flatpaks.service as a **user** systemd service for automatic updates.

It is recommended that you follow the docs [here](https://www.qubes-os.org/doc/vm-sudo/#replacing-passwordless-root-access-with-dom0-user-prompt) to make a prompt for root access on non-minimal VMs. dom0.sh already takes care of dom0 so you only need to worry about the guests. Skip whonix-gateway as it will create an annoying prompt every time a VM attached to it boots.

## Laptop Recommendations

Qubes AEM currently still requires legacy boot. Officially, the last generation of Intel CPUs with VBIOS to support legacy boot Coffee Lake. However, I have found that certain Comet Lake Thinkpads still have legacy support.

I recommend that you look though [Lenovo's BIOS simulator](https://download.lenovo.com/bsco/index.html#/) to find a suitable Comet Lake Thinkpad. These will have the longest remaining support lifecycle. Personally, I use a Thinkpad T14 gen 1.

## Lenovo ePrivacy

Lenovo ePrivacy can be controlled through `/proc/acpi/ibm/lcdshadow`. I use the following shortcuts:

- F5: `sudo bash -c 'echo 1 > /proc/acpi/ibm/lcdshadow'`
- F6: `sudo bash -c 'echo 0 > /proc/acpi/ibm/lcdshadow'`
