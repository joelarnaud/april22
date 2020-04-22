#!/bin/bash

#echo -e "\n display the following answer in different colum  \n"

#echo -e "\v\t$(getconf LONG_BIT)\t$(ps -ef |wc -l)\nowner of this code is joel\n\tborn at yaounde\n\t\vin cameroon"

#touch /tmp/log

#groupadd shipping


b=$(egrep 'SELINUX=e|SELINUX=p|SELINUX=d' /etc/selinux/config | awk -F= '{print$2}')

if [ ${b} == enforcing ]
then
echo this system is secure
else
echo this system does not met security requirements
fi

echo -e "\ncheck if the system can boot up in interactive mode and if the system require the root password in maintenance mode\n" 

c=$(grep PROMPT /etc/sysconfig/init |awk -F= '{print$2}')
if [ ${c} == yes ]
then 
echo system can boot in iteractive mode
else
echo system can not boot in interactive mode
fi
echo

d=$(grep SINGLE /etc/sysconfig/init | awk -F/ '{print$3}')
if [ ${d} == sulogin ]
then
echo you need a root password
else
echo anybody can take this system
fi

function inventory {
echo -e "\n 1. check if the user ansible exist on the system \n"
id ansible >/dev/null 2>&1
if [ $? -eq 0 ]
then 
echo user ansible exist
else
echo user ansible does not exist
fi
echo -e "\n 2. check if the package git is install \n"
rpm -qa | grep git >/dev/null 2>&1
if [ $? -eq 0 ]
then
echo package is install
else
echo package is not install
fi
echo -e "\n 3. check if inittab, grub.conf, fstab file exist \n"
if [ -f /etc/inittab ] && [ -f /etc/grub.conf ] && [ -f /etc/fstab ]
then
echo files exist
else
echo files do not exist
fi
echo -e "\n 4. check if the system has two processors \n"
p=$(nproc)
if [ ${p} -lt 2 ]
then
echo system has $(nproc) processors, it need to be update
else
echo system has not two processors
fi
echo -e "\n 5. check if the system is 32 or 64 bits \n"
g=$(getconf LONG_BIT)
if [ ${g} -eq 32 ]
then
echo system is $(getconf LONG_BIT) bits
else
echo system in not 32 bits 
fi
echo -e "\n 6. the kernel version need to be at least 3 \n"
k=$(uname -r |awk -F. '{print$1}')
if [ ${k} -lt 3 ]
then
echo the kernel is $(uname -r | awk -F. '{print$1}'), it is not up to date
else
echo kernel is up to date
fi
echo -e "\n 7. the OS version need to be at least 6.5 \n"
o=$(grep 6.4 /etc/issue | awk '{print$3}' | awk -F. '{print$2}') 
if [ ${o} -lt 5 ]
then
echo OS version is $(grep 6.4 /etc/issue | awk '{print$3}'), it is not up to date
else
echo OS version is up to date
fi
echo -e "\n 8. check the memory it should be at least 4000MB \n"
m=$(grep Mem /proc/meminfo | awk '{print$2}' |head -1)
if [ ${m} -lt 4000000 ]
then
echo the memory is $(grep Mem /proc/meminfo | awk '{print$2}' |head -1) kb
else
echo the memory is correct
fi
echo -e "\t\vWE\vCAN\vADD\vMORE"
}
inventory
echo 
inventory
