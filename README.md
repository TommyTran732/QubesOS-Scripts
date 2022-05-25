# QubesOS-Scripts
My Scripts for template VMs

1. For the normal Fedora TemplateVMs, run the fedora.sh first to trim down the Fedora template, then base the other templates on it.
2. The Fedora minimal templates should be based directly on the Fedora minimal template.
3. VMs running Flatpak should be using Fedora instead of Debian for newer packages. I only use Debian for packages that I can get directly from the developer instead of through a third party like Signal, Element, etc.
4. The whonix hardening script should be run on both the workstation and gateway.
