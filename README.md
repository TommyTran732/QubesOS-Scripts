# QubesOS-Scripts
My scripts for setting up QubesOS

1. Run dom0.sh script to set up dom0
2. Download the Fedora Minimal template and use the Fedora Minimal scripts to create TemplateVMs based on it. The most important thing here is that you replace sys-net and sys-firewall with a minimal version for attack surface reduction. I have been trying to create a minimal template for ProtonVPN, but haven't been able to so far. Any help with this would be appreciated.
3. Run the fedora.sh script to trim down the default Fedora template and do basic configuration. Other TemplateVMs should be based on the trimmed down Fedora template.
4. Run the whonix_hardening.sh script on both the Whonix Gateway and Workstation templates to enable experimental hardening features.
