#!/bin/bash

# Store all the required system information in variables
arch=`uname -a`

phys_cpu=`grep "physical id" /proc/cpuinfo | sort | uniq | wc -l`
virt_cpu_cores=`grep "processor" /proc/cpuinfo | wc -l`

total_ram=`free -m | grep "Mem:" | awk '{print $2}'`
used_ram=`free -m | grep "Mem:" | awk '{print $3}'`
ram_percentage=`free -m | grep "Mem:" | awk '{printf("%.2f%%"), $3/$2*100}'`

root_lvm_size=`df -Bg | grep '^/dev/' | grep -v '/boot' | awk '{print $2}' | head -n 1 | sed 's/[^0-9]*//g'`
root_lvm_used=`df -Bm | grep '^/dev/' | grep -v '/boot' | awk '{print $3}' | head -n 1 | sed 's/[^0-9]*//g'`
disk_percentage=`printf('test disk perc')`


cpu_load=`top -b -n 1 | grep "%Cpu" | awk '{printf("%.1f%%"), $2 + $4}'`
last_reboot=`who -b | rev | awk '{print $1,$2}' | rev`

lvm_active=`lsblk | grep lvm | wc -l`
lvm_yesno=`if [ $lvm_active -eq 0 ]; then echo "no"; else echo "yes"; fi`

tcp_inuse=`cat /proc/net/sockstat | grep "TCP" | awk '{print $3}'`
logged_users=`users | wc -w`
ipv4=`hostname -I`
mac_adddr=`ip link show | grep "link/ether" | awk '{print $2}'`
sudo_cmds=`sudo journalctl _COMM=sudo | grep "COMMAND" | wc -l`
#wall "	#Architecture: $arch
	#CPU physical: $phys_cpu
	#vCPU: $virt_cpu_cores
	#Memory Usage: $uram/${fram}MB ($pram%)
	#Disk Usage: $udisk/${fdisk}Gb ($pdisk%)
	#CPU load: $cpul
	#Last boot: $lb
	#LVM use: $lvmu
	#Connexions TCP: $ctcp ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmds cmd" 

echo "$used_ram/${total_ram}MB ($ram_percentage)"
echo "$root_lvm_used/$root_lvm_size"
echo "cpu load : $cpu_load"
echo $disk_percentage