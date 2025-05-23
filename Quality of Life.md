## Quality of Life

### LUKS Discard

By default, Qubes does not use discard with a LUKS volume. To enable discard, run:

```bash
sudo cryptsetup --allow-discards --persistent refresh LUKS-UUID-HERE
```

### Auto login

The first login prompt after the encryption password is security theatre, so we can skip it entirely. Make `/etc/lightdm/lightdm.conf.d/autologin`:

```
[Seat:*]
autologin-user=USERNAME
```

### S0ix sleep

On certain hardware like the Thinkpad T14 Gen 1, you need to enable S0ix sleep support for suspension to work correctly. Use the following command:

```bash
sudo qvm-features dom0 suspend-s0ix 1
```

### Default appmenu

The default apps to show on AppVMs' menu when created can be configured with `qvm-features`.

Example:

```bash
sudo qvm-features fedora-41 default-menu-items 'org.gnome.Nautilus.desktop org.gnome.Ptyxis.desktop'
sudo qvm-features fedora-41 netvm-menu-items 'org.gnome.Ptyxis.desktop'

sudo qvm-features debian-12 default-menu-items 'org.gnome.Console.desktop org.gnome.Nautilus.desktop'
sudo qvm-features debian-12 netvm-menu-items 'org.gnome.Console.desktop'
```

### Fedora memory limit

Currently Qubes has [this bug](https://github.com/QubesOS/qubes-issues/issues/9663). Supposedly it has been fix, but I still notice my Fedora VMs getting stuck at 400 MB RAM after a few updates.
To work around this for now, I change the minimum memory for all of my Fedora Template VMs to 2000 MB.

### Lenovo ePrivacy

Lenovo ePrivacy can be controlled through `/proc/acpi/ibm/lcdshadow`. I use the following shortcuts:

- F5: `sudo bash -c 'echo 1 > /proc/acpi/ibm/lcdshadow'`
- F6: `sudo bash -c 'echo 0 > /proc/acpi/ibm/lcdshadow'`

### FIDO2 policies
The GUI configurator are missing 2 important policies needed for FIDO2 to work correctly, namely `ctap.GetInfo` and `ctap.ClientPin`.

Personally, I created `/etc/qubes/policy.d/50-ctap.policy` (note that I don't touch `/etc/qubes/policy.d/50-config-u2f.policy` to avoid it being overwritten by the GUI tool):

```
ctap.GetInfo    *  microsoft-edge  sys-usb  allow
ctap.ClientPin  *  microsoft-edge  sys-usb  allow
```

### Split GPG
The GUI configurator is very broken so I don't use it. Instead, I write my own policy at `/etc/qubes/policy.d/50-gpg.policy`
```
qubes.Gpg  *  thunderbird  vault  allow
```

Note that I just use allow here, because the vault VM on a new Fedora 41 already prompts for confirmation, so I don't wanna have to answer yet another prompt from dom0.

### qvm-screenshot-tool

```bash
sudo qubes-d0m-update maim zenity
```

Copy [this file](https://github.com/ben-grande/qubes-qvm-screenshot-tool/blob/master/qvm-screenshot) to `/usr/local/bin` in dom0.

```bash
sudo chmod +x /usr/local/bin
```

Set the `PrntSc` button to run `qvm-screenshot` in shortcut settings.

### Trivial data exfiltration prevention

One trivial way for malicious applications to exfiltrate data from an offline VM is to open a link in a disposable VM with a payload. To prevent this, open Qubes Global Config -> URL handing -> All Qubes will ask and default to Default Disposable Template.

### Edge Dark Mode

Go to `edge://flags` and set "Auto Dark Mode for Web Contents" to "Enable with selective inversion of non-image elements". This reduces flashbangs a lot.

### Firefox based browsers

Currently Firefox based browsers [will break](https://github.com/QubesOS/qubes-issues/issues/8612#issuecomment-1764832181) when you try to open a YouTube video in fullscreen if their window is maximized. To workaround this, set `full-screen-api.ignore-widgets` in `about:config` to true. 

I have no idea if this will make you more fingerprintable or not.

### Bitwarden & Element Flatpak

These apps require the keyring to be created first to work properly. Simply open a browser like Microsoft Edge and set an empty password for the keyring before using them.

### Video player

In my experience, VLC works best. Changing video output to X11 video output (XCB) reduces CPU usage by 10% on my Thinkpad P53. See [this link](https://forum.qubes-os.org/t/vlc-video-playback-cpu-usage-improvement/23363).

If you want to use MPV, make sure that `--vo=x11 --profile=sw-fast` is passed as arguments. See [this link](https://forum.qubes-os.org/t/improving-video-playback-speed/21906).
