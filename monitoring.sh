#!/bin/bash

# Store all the required system information in variables
arch=`uname -a`
phys_cpu=`grep "physical id" /proc/cpuinfo | sort | uniq | wc -l`
virt_cpu_cores=`grep "processor" /proc/cpuinfo | wc -l`
total_ram=`free -m | awk '$1 == "Mem:" {print $2}'`
used_ram=`free -m | awk '$1 == "Mem:" {print $3}'`
ram_percentage=`echo "scale=2; ($used_ram / $total_ram) * 100" | bc`
echo $ram_percentage