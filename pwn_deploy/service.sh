#!/bin/bash

chmod 700 ./service.sh
chmod 755 /home

port=1800
uid=1000

files=$(ls /home)
for filename in $files
do
    echo "service ctf">> xinted.conf
    echo "{" >> xinted.conf
    echo "    disable = no">> xinted.conf
    echo "    socket_type = stream">> xinted.conf
    echo "    protocol    = tcp">> xinted.conf
    echo "    wait        = no">> xinted.conf
    echo "    user        = root">> xinted.conf
    echo "    type        = UNLISTED">> xinted.conf
    echo "    port        = $port">> xinted.conf
    echo "    bind        = 0.0.0.0">> xinted.conf
    echo "    server      = /usr/sbin/chroot"  >> xinted.conf 
    echo "    server_args = --userspec=$uid:$uid /home/$filename ./$filename">> xinted.conf
    echo "    per_source  = 6" >> xinted.conf # the maximum instances of this service per source IP address
    echo "    rlimit_cpu  = 60">> xinted.conf # the maximum number of CPU seconds that the service may use
    echo "    rlimit_as  = 100M">> xinted.conf # the Address Space resource limit for the service
    echo "}" >> xinted.conf

    useradd -m $filename
    chown -R root:$filename /home/$filename
    chmod -R 750 /home/$filename
    chmod 740 /home/$filename/flag.txt

    cp -R /lib* /home/$filename
    cp -R /usr/lib32/* /home/$filename/lib32/
    mkdir /home/$filename/dev
    mknod /home/$filename/dev/null c 1 3
    mknod /home/$filename/dev/zero c 1 5
    mknod /home/$filename/dev/random c 1 8
    mknod /home/$filename/dev/urandom c 1 9
    chmod 666 /home/$filename/dev/* 

    let port=$port+1
    let uid=$uid+1
done

mv ./xinted.conf /etc/xinetd.d/pwn

/etc/init.d/xinetd start;
sleep infinity;


