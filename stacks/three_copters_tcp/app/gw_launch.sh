#!/bin/bash
mavlink-routerd -p $(getent ahostsv4 copter_1 | head -1 | awk '{print $1}'):5760 -p $(getent ahostsv4 copter_2 | head -1 | awk '{print $1}'):5760 -p $(getent ahostsv4 copter_3 | head -1 | awk '{print $1}'):5760
