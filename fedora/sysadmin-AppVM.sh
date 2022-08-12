#!/bin/bash

#Run this in an AppVM, not a TemplateVM

echo '# SPLIT SSH CONFIGURATION >>>
# replace "vault" with your AppVM name which stores the ssh private key(s)
SSH_VAULT_VM="vault"

if [ "$SSH_VAULT_VM" != "" ]; then
  export SSH_SOCK="/home/user/.SSH_AGENT_$SSH_VAULT_VM"
  rm -f "$SSH_SOCK"
  sudo -u user /bin/sh -c "umask 177 && exec socat 'UNIX-LISTEN:$SSH_SOCK,fork' 'EXEC:qrexec-client-vm $SSH_VAULT_VM qubes.SshAgent'" &
fi
# <<< SPLIT SSH CONFIGURATION' | sudo tee -a /rw/config/rc.local

echo '# SPLIT SSH CONFIGURATION >>>
# replace "vault" with your AppVM name which stores the ssh private key(s)
SSH_VAULT_VM="vault"

if [ "$SSH_VAULT_VM" != "" ]; then
  export SSH_AUTH_SOCK="/home/user/.SSH_AGENT_$SSH_VAULT_VM"
fi
# <<< SPLIT SSH CONFIGURATION' | tee -a ~/.bashrc