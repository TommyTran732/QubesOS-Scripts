## Quality of Life

### Video player

In my experience, VLC works best. Changing video output to X11 video output (XCB) reduces CPU usage by 10% on my Thinkpad P53. See [this link](https://forum.qubes-os.org/t/vlc-video-playback-cpu-usage-improvement/23363).

If you want to use MPV, make sure that `--vo=x11 --profile=sw-fast` is passed as arguments. See [this link](https://forum.qubes-os.org/t/improving-video-playback-speed/21906).
