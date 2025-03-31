#!/bin/bash
USERNAME="nessus"
USER_HOME="/home/$USERNAME"
PUBKEY_CONTENT="{{PUBKEY}}"

if [[ $EUID -ne 0 ]]; then
  echo "Run as root."
  exit 1
fi

# Create the user if it doesn't exist
id "$USERNAME" &>/dev/null || useradd -m -s /bin/bash "$USERNAME"

# Lock the user's password
passwd -l "$USERNAME"

# Set up the SSH directory and authorized keys
mkdir -p "$USER_HOME/.ssh"
echo "$PUBKEY_CONTENT" > "$USER_HOME/.ssh/authorized_keys"
chmod 600 "$USER_HOME/.ssh/authorized_keys"
chmod 700 "$USER_HOME/.ssh"
chown -R "$USERNAME:$USERNAME" "$USER_HOME/.ssh"

# Set a compatible PS1 for scanning
echo "export PS1='\[\u@\h \W\]\\$ '" >> "$USER_HOME/.bashrc"
chown "$USERNAME:$USERNAME" "$USER_HOME/.bashrc"

# Grant passwordless sudo access
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
chmod 440 /etc/sudoers.d/$USERNAME

echo "[✔] $USERNAME user configured."
