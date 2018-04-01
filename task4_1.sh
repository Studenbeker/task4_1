#!/bin/bash
dir=$(dirname $0)

exec 1> $dir/task4_1.out

BSN=(`dmidecode -s baseboard-serial-number`)
if [ $BSN == 0 ];
then
BSN=Unkown
fi
SSN=(`dmidecode -s system-serial-number`)
if [ $SSN == 0 ];
then
SSN=Unkown
fi

echo "--- HARDWARE ---"
echo "CPU"`cat /proc/cpuinfo | grep "model name" | sed -n 1p | grep -oP '(?=:).*'`
echo "RAM: "`free | grep Mem | awk '{print $2}'` "KB"
echo "Motherboard: "`dmidecode -s baseboard-manufacturer`" "`dmidecode -s baseboard-product-name`" "`dmidecode -s baseboard-version` $BSN
echo "System serial number: "$SSN
echo "--- SYSTEM ---"
echo "OS Distribution: "`lsb_release -d --short`
echo "Kernel version: "`uname -r`
echo "Installation date: "`cat /var/log/dpkg.log | grep "install linux-firmware" | awk '{print $1}'`
echo "Hostname: "`hostname`
echo "Uptime: "`uptime -p | awk '{print $2,$3,$4,$5,$6,$7,$8}'`
echo "Processes running: "`ps aux --no-headers | wc -l`
echo "User logged in: "`who | wc -l`
echo "--- NETWORK ---"

NEWIF=(`ip address | awk '/mtu/{print $2}'`)

NEWIP=(`ip address | awk '/inet /{print $2}'`)

for (( i=0 ; i < ${#NEWIF[*]} ; i++ ))
do
if [ -z  "${NEWIP[$i]// /}" ];
then
printf  "${NEWIF[$i]} -\n"
else
printf  "${NEWIF[$i]} ${NEWIP[$i]}\n"

fi

done
