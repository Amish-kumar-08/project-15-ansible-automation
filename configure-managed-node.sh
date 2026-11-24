
#!/bin/bash
set -eux

# Prepare SSH runtime directory
mkdir -p /run/sshd

# Configure SSH to listen on port 2222
if ! grep -qE '^[[:space:]]*Port[[:space:]]+2222([[:space:]]|$)' /etc/ssh/sshd_config; then
    echo 'Port 2222' >> /etc/ssh/sshd_config
fi

# Validate SSH configuration
/usr/sbin/sshd -t

# Switch from socket activation to SSH service
systemctl disable --now ssh.socket || true
systemctl enable ssh.service
systemctl restart ssh.service

