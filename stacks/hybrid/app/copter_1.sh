#!/bin/sh
mkdir -p /app/copter_1
cd /app/copter_1
/ardupilot/build/sitl/bin/arducopter -w --model=quad --home=51.423422,-2.67161,0,180 --defaults /app/copter.parm --sysid=1
