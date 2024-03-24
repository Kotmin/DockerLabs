#!/bin/bash

# Sprawdzenie, czy skrypt jest uruchamiany z uprawnieniami roota
if [ "$EUID" -ne 0 ]; then
  echo "Proszę uruchomić skrypt jako root"
  exit
fi

# Usunięcie kontenerów
docker stop T1 T2 D1 D2 S1 late
docker rm T1 T2 D1 D2 S1 late

# Usunięcie sieci użytkownika
docker network rm bridge1 bridge2

# Opcjonalnie: Resetowanie polityki iptables
# Należy zachować ostrożność, aby nie usunąć żadnych ważnych reguł
# iptables -P FORWARD DROP # Przywróć domyślną politykę, jeśli była zmieniona
# sudo sysctl net.ipv4.conf.all.forwarding=0 # Wyłączenie przekazywania pakietów IP

echo "Wszystkie zmiany wprowadzone przez oryginalny skrypt zostały cofnięte."

