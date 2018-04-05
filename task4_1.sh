#!/bin/bash
dir=$(dirname $0)

exec 1> $dir/task4_1.out

echo "--- HARDWARE ---"
echo "CPU"`cat /proc/cpuinfo | grep "model name" | sed -n 1p | grep -oP '(?=:).*'`
echo "RAM: "`free | grep Mem | awk '{print $2}'` "KB"
MF=$(dmidecode -s baseboard-manufacturer)
MBOARD=$(dmidecode -s baseboard-product-name)

if [[ $MBOARD == "Unknown" && $MFR=="Unknown" ]] ; 
then
echo "Motherboard: Unknown"
else 
echo "Motherboard:" $MF $MBOARD 
fi
SERIAL=$(dmidecode -s system-serial-number)
[[ -z $SERIAL ]] && SERIAL=Unknown

echo "System Serial Number: "$SERIAL
echo "--- SYSTEM ---"
echo "OS Distribution: "`lsb_release -d --short`
echo "Kernel version: "`uname -r`
echo "Installation date:" $(ls -alct /|tail -1|awk '{print $6, $7, $8}')
echo "Hostname: "$(hostname -f)
echo "Uptime: "`uptime -p | awk '{print $2,$3,$4,$5,$6,$7,$8}'`
echo "Processes running: "`ps aux --no-headers | wc -l`
echo "User logged in: "`who | wc -l`
echo "--- Network ---"
for IF in `ip address | awk '/mtu/{print $2}'` 
do IP=(`ip address show "${IF}" | awk '/inet /{print $2}' | xargs`) 
if [ -z "$IP" ]; 
then echo "${IF} -" 
else echo "${IF}" `ip address show "${IF}" | awk '/inet /{print $2}' | xargs | sed 's/\ /, /g'` 
fi


done
