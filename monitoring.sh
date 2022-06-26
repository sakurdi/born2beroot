#!/bin/bash

# Store all the required system information in variables
arch=`uname -a`
phys_cpu=`grep "physical id" /proc/cpuinfo | sort | uniq | wc -l`
virt_cpu_cores=`grep "processor" /proc/cpuinfo | wc -l`
