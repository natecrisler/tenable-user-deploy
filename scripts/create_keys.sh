#!/bin/bash
mkdir -p keys
ssh-keygen -t ecdsa -b 521 -f keys/nessus_id_ecdsa -N ""
echo "[✔] SSH key pair created in ./keys/"
