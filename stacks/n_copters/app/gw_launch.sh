#!/bin/bash
mavlink-routerd -p $(/app/get_host_ip.sh copter_1):5760 -p $(/app/get_host_ip.sh copter_2):5760
