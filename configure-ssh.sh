#!/bin/bash
set -e

if ! grep -qE '^[[:space:]]*Port[[:space:]]+2222([[:space:]]|$)' /etc/ssh/sshd_config; then
    echo 'Port 2222' >> /etc/ssh/sshd_config
fi

sshd -t
systemctl restart ssh
