#!/usr/bin/env bash
set -e

echo "=== Tailscale Setup ==="
read -rsp "Masukkan Tailscale Auth Key: " TS_AUTHKEY
echo

if [ -z "$TS_AUTHKEY" ]; then
    echo "Key tidak boleh kosong."
    exit 1
fi

echo "[1/4] Install Tailscale..."

if ! command -v tailscale >/dev/null 2>&1; then
    curl -fsSL https://tailscale.com/install.sh | sh
fi

echo "[2/4] Menjalankan tailscaled..."

sudo pkill tailscaled 2>/dev/null || true

sudo tailscaled \
    --state=/tmp/tailscaled.state \
    --socket=/tmp/tailscaled.sock \
    >/tmp/tailscaled.log 2>&1 &

sleep 3

echo "[3/4] Login menggunakan Auth Key..."

sudo tailscale --socket=/tmp/tailscaled.sock up \
    --auth-key="$TS_AUTHKEY"

echo "[4/4] IP Tailscale:"

sudo tailscale --socket=/tmp/tailscaled.sock ip -4
