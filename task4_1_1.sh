#!/bin/bash 

slog="$PWD"/task4_1.out

        function main {
echo ----------------------HARDWARE---------------------- 
echo "CPU"`cat /proc/cpuinfo | grep "model name" | grep -oP '(?=:).*'`
echo "RAM: "`free | grep Память | awk '{print $2}'` "kb"

BSN=("`dmidecode -s baseboard-serial-number`")
if [ $BSN == 0 ];
then
BSN=Unkown
fi
echo "System serial number: $BSN" 
echo "Motherboard: "`dmidecode -s baseboard-manufacturer`"/"`dmidecode -s baseboard-product-name`"/Ver. "`dmidecode -s baseboard-version`/$BSN
echo -----------------------SYSTEM----------------------- 
echo "OS Distribution: "`lsb_release -d --short`
echo "Installation date: "`ls -l /var/log/installer | sed -n 6p | awk '{print $7,$6}'`
echo "Kernel version: "`uname -r`
echo "Hostname: "`hostname`
echo "Uptime: "`uptime | awk '{print $3}' | sed 's/,$//'`" H/min"
echo "Processes running: "`ps | sed -n 6p | awk '{print $1}'`
echo "User logged in: "`who | awk '{print $1}'`
echo ----------------------NETWORK----------------------- 
NEW_IP=(`ifconfig -a | awk '/inet addr/{ sub(/addr:/, ""); print $2}' -`)
NEW_MA=(`ifconfig -a | grep "inet addr" | awk 'NF>1{print $NF}' | grep -oP '(?=2).*'`)
NEW_IF=(`ifconfig | awk '/encap/{print $1}'`)
for (( i=0; i <= 10; i++ ))
do
printf "${NEW_IF[$i]}\t${NEW_IP[$i]}\t${NEW_MA[$i]}\n"
        done
         }
                main 2>&1 | tee $slog
