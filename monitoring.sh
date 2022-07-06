#!/bin/bash

# Store all the required system information in variables
arch=`uname -a`

phys_cpu=`grep "physical id" /proc/cpuinfo | sort | uniq | wc -l`
virt_cpu_cores=`grep "processor" /proc/cpuinfo | wc -l`

total_ram=`free -m | grep "Mem:" | awk '{print $2}'`
used_ram=`free -m | grep "Mem:" | awk '{print $3}'`
ram_percentage=`free -m | grep "Mem:" | awk '{printf("%.2f%%"), $3/$2*100}'`

root_lvm_size=`df -Bg | grep '^/dev/' | grep -v '/boot' | head -n 1 | awk '{print $2+0}'`
root_lvm_used=`df -Bm | grep '^/dev/' | grep -v '/boot' | head -n 1 | awk '{print $3+0}'`
root_total_percentage=`df -Bm | grep '^/dev/' | grep -v '/boot' | head -n 1 | awk '{printf("%d%%"), ($3+0)/($2+0) * 100} '`


cpu_load=`top -b -n 1 | grep "%Cpu" | awk '{printf("%.1f%%"), $2 + $4}'`
last_reboot=`who -b | rev | awk '{print $1,$2}' | rev`

lvm_active=`lsblk | grep lvm | wc -l`
lvm_yesno=`if [ $lvm_active -eq 0 ]; then echo "no"; else echo "yes"; fi`

tcp_inuse=`cat /proc/net/sockstat | grep "TCP" | awk '{print $3}'`
logged_users=`users | wc -w`
ipv4=`hostname -I`
mac_adddr=`ip link show | grep "link/ether" | awk '{print $2}'`
sudo_cmds=`sudo journalctl _COMM=sudo | grep "COMMAND" | wc -l`
wall "	#Architecture: $arch
	#CPU physical: $phys_cpu
	#vCPU: $virt_cpu_cores
	#Memory Usage: $used_ram/${total_ram}MB ($ram_percentage)
	#Disk Usage: $root_lvm_used/${root_lvm_size}Gb ($root_total_percentage)
	#CPU load: $cpu_load
	#Last boot: $last_reboot
	#LVM use: $lvm_yesno
	#Connexions TCP: $tcp_inuse ESTABLISHED
	#User log: $logged_users
	#Network: IP $ipv4 ($mac_adddr)
	#Sudo: $sudo_cmds cmd" 

#echo "$used_ram/${total_ram}MB ($ram_percentage)"
#echo "cpu load : $cpu_load"
#echo "disk perc $root_lvm_used/$root_lvm_size ($root_total_percentage)"
