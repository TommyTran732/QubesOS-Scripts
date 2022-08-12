#!/bin/bash

echo '#!/bin/sh
# Qubes App Split SSH Script

# Activate GPG Agent and set the correct SSH socket
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# safeguard - Qubes notification bubble for each ssh request
notify-send "[$(qubesdb-read /name)] SSH agent access from: $QREXEC_REMOTE_DOMAIN"

# SSH connection
socat - "UNIX-CONNECT:$SSH_AUTH_SOCK"' | sudo tee /etc/qubes-rpc/qubes.SshAgent

sudo chmod +x /etc/qubes-rpc/qubes.SshAgent