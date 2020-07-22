#!/bin/bash
rm docker-compose.yml

port=1800
pwndict="./pwnfiles"
pwn_num=$(ls $pwndict -l |grep "^d" | wc -l)

echo "version: '2'" >> docker-compose.yml
echo "services:" >> docker-compose.yml
echo " pwn_deploy_chroot:" >> docker-compose.yml
echo "   image: pwn_deploy_chroot:latest" >> docker-compose.yml
echo "   build: ." >> docker-compose.yml
echo "   container_name: pwn_deploy_chroot" >> docker-compose.yml
echo "   ports:" >> docker-compose.yml
for i in `seq 1 $pwn_num`
do
    echo "    - $port:$port">> docker-compose.yml
    let port+=1
done
echo "   volumes:" >> docker-compose.yml
echo "    - ./pwnfiles:/home" >> docker-compose.yml
echo "    - ./service.sh:/service.sh" >> docker-compose.yml
echo "   command: bash /service.sh" >> docker-compose.yml
