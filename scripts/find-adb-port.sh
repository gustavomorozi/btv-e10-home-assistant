#!/usr/bin/env bash
# Procura a porta TCP do ADB numa TV box (Linux/macOS).
# Uso: ./find-adb-port.sh 192.168.0.X
# Depois: adb connect IP:PORTA
set -euo pipefail
ip="${1:?uso: $0 IP_DA_CAIXA}"

if command -v nmap >/dev/null 2>&1; then
  echo "Varrendo $ip com nmap (todas as portas TCP)..."
  nmap -p- --open -T4 "$ip" | grep -E '^[0-9]+/tcp' || echo "Nenhuma porta aberta."
else
  echo "nmap nao encontrado; tentando com bash (/dev/tcp) nas portas 1-65535, pode demorar..."
  for p in $(seq 1 65535); do
    (timeout 0.2 bash -c "echo > /dev/tcp/$ip/$p") 2>/dev/null && echo "$p aberta"
  done
fi
echo "Teste cada porta: adb connect $ip:PORTA  (a do adbd costuma ser alta, ex.: 11993)"
