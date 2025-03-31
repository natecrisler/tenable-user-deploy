#!/bin/bash
PUBKEY_FILE=keys/nessus_id_ecdsa.pub
DEPLOY_SCRIPT=scripts/deploy_nessus_user.sh
HOSTS_FILE=hosts/hosts.txt
REMOTE_USER=vagrant

PUBKEY=$(cat "$PUBKEY_FILE")
TEMP_SCRIPT=$(mktemp)
sed "s|{{PUBKEY}}|$PUBKEY|" "$DEPLOY_SCRIPT" > "$TEMP_SCRIPT"

while read -r HOST; do
  echo "[*] Deploying to $HOST..."
  scp "$TEMP_SCRIPT" "$REMOTE_USER@$HOST:/tmp/deploy_nessus_user.sh"
  ssh "$REMOTE_USER@$HOST" "sudo bash /tmp/deploy_nessus_user.sh && sudo rm /tmp/deploy_nessus_user.sh"
  echo "[+] Done with $HOST"
done < "$HOSTS_FILE"

rm "$TEMP_SCRIPT"
