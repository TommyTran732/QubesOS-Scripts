# Enable SELinux

To enable SELinux, do the following after you have run fedora-minimal.sh:
- Shutdown the VM.
- Run `qvm-features fedora-41-minimal selinux 1`.
- Start the minimal VM.
- Edit /etc/sysconfig/selinux and change SELINUX mode to enforcing.
- Restart the VM.
