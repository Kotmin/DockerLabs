#!/bin/bash

# Sprawdzenie, czy skrypt jest uruchamiany z uprawnieniami roota
if [ "$EUID" -ne 0 ]
  then echo "Proszę uruchomić skrypt jako root"
  exit
fi

# Sprawdzenie, czy narzędzie brctl jest zainstalowane
if ! command -v brctl &> /dev/null; then
    echo "Narzędzie 'brctl' nie jest zainstalowane. Instaluję 'bridge-utils'."
    apt-get update && apt-get install -y bridge-utils
fi

# docker0 teoretycznie jest zawsze utworzony możemy sobie go podejrzeć
brctl show


# Ustawienie polityki iptables
sudo iptables -P FORWARD ACCEPT
sudo sysctl net.ipv4.conf.all.forwarding=1



# Tworzenie sieci użytkownika bridge1 z podanym zakresem adresów
docker network create --driver bridge --subnet=10.0.10.0/24 bridge1

# Tworzenie sieci bridge2, która będzie miała bezpośredni dostęp do interfejsu hosta
docker network create --driver bridge bridge2

# Sprawdzenie czy się udało, spodziewamy sie b,b1,b2 gdzie b = bridge
docker network ls

# Uruchomienie kontenera „T1”
docker run -itd --name T1 -p 8080:80 alpine sh

# check czy sie udalo
docker exec T1 ip addr

# Uruchomienie kontenera „T2” opartego o obraz nginx i podpięcie do sieci bridge1 z mapowaniem portu 80 na port hosta
#docker run -itd --name T2 --network bridge1 --expose 80 - 80:80 nginx 
docker run -itd --name T2 --network bridge1 -p 80:80 nginx
docker inspect T2 | jq '.[].NetworkSettings'

# Uruchomienie kontenerów „D1” i „D2” opartych odpowiednio o obrazy alpine i httpd, przyłączenie do sieci bridge1 i bridge2
docker run -d --name D1 --network bridge1 --ip 10.0.10.254 alpine
docker inspect D1 | jq '.[].NetworkSettings'

# D2 bezpośredni dostęp do int hosta macierzystego, p 80 na 8000 hosta
docker run -d --name D2 --expose 80 -p 8000:80 httpd
docker network connect bridge1 D2
docker network connect bridge2 D2
docker network disconnect bridge D2

docker inspect D2 | jq '.[].NetworkSettings'


# Uruchomienie kontenera „S1” na bazie obrazu zubuntu i przyłączenie do sieci bridge2
docker run -itd --name S1 --network bridge2 ubuntu
docker inspect S1 | jq '.[].NetworkSettings'

# Tworzenie kontenera „late” na bazie obrazu zubuntu bez uruchamiania, przyłączenie do obu sieci, a następnie uruchomienie
docker run -itd --name late ubuntu
docker network connect bridge1 late
docker network connect bridge2 late
docker network disconnect bridge late

# Sprawdzenie konfiguracji sieci

sudo iptables -L -v

# Sprawdzamy czy mamy zainstalowany program route

## Dla Hosta opartego o system Ubuntu
if ! command -v route &> /dev/null
then
    echo "Polecenie 'route' nie jest zainstalowane. Instaluję 'net-tools'."
    apt-get update && apt-get install -y net-tools
fi

## Dla T2 opartego o Debian lub Alpine
docker exec T2 sh -c 'if ! command -v route &> /dev/null; then apk update && apk add iproute2; fi; route -n'

docker exec T2 bash -c 'if ! command -v route &> /dev/null; then apt-get update && apt-get install -y net-tools; fi; route -n'


## Dla D2 opartego o Debian

docker exec D2 bash -c 'if ! command -v route &> /dev/null; then apt-get update && apt-get install -y net-tools; fi; route -n'



# Sprawdzenie tablic routingu HOST,T2,D2

# Wyświetlenie tablicy routingu hosta
echo "Tablica routingu hosta:"
route -n
echo "--------------------------------"

# Wyświetlenie tablicy routingu dla kontenera T2
echo "Tablica routingu kontenera T2:"
docker exec T2 route -n
echo "--------------------------------"

# Wyświetlenie tablicy routingu dla kontenera D2
echo "Tablica routingu kontenera D2:"
docker exec D2 route -n
echo "--------------------------------"


