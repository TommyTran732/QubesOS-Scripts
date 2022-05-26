# QubesOS-Scripts
My scripts for setting up QubesOS. Read the scripts and adjust them to your needs, don't just blindly run them.

1. Run dom0.sh script to set up dom0
2. Download the Fedora Minimal template and use the fedora-minimal.sh script to do basic configuration. Then, create TemplateVMs based on it. The most important thing here is that you replace sys-net and sys-firewall with a minimal version for attack surface reduction. I have been trying to create a minimal template for ProtonVPN, but haven't been able to so far. Any help with this would be appreciated.
3. Run the fedora.sh script to trim down the default Fedora template and do basic configuration. The script includes a systemd user timer `update-user-flatpaks.timer` that you can manually enable on AppVMs. Firefox is also replaced with Brave. Other TemplateVMs should be based on the trimmed down Fedora template. 
4. Copy the Fedora template to a Brave template. Run brave.sh to install brave in the brave template. TemplateVMs which need a dedicated browser should be based on the Brave template of the Fedora template. Create a disposable VM based on the Brave template. When you need to open a browser inside of a VM with no browser, Qubes will open it in a disposable VM instead.
5. Run debian.sh to trim down the Debian template.
6. Copy the Debian template to a Kicksecure template, then run kicksecure.sh to morph it into Kicksecure. AppVMs should be based on KickSecure instead of Debian.
7. Run the kicksecure_hardening.sh script on both the Whonix Gateway and Workstation templates to enable experimental hardening features. The same script can be used to harden AppVMs based on KickSecure too, so long as it doesn't stop your app from running.
