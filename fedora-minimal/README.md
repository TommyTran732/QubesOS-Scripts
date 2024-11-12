# Enable SELinux

To enable SELinux, do the following after you have run fedora-minimal.sh:
- Shutdown the VM
- Run `qvm-features fedora-40-minimal selinux 1`.
- Start the minimal vm. Wait for it to shut itself down.
- Run `qvm-features fedora-40-minimal selinux 0`.
- Turn the VM on, remove `/.autorelabel`.
- Turn the VM off.
- Run `qvm-features fedora-40-minimal selinux 1`.