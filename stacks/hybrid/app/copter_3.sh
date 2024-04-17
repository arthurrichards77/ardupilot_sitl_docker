#!/bin/sh
mkdir -p /app/copter_3
cd /app/copter_3
/ardupilot/build/sitl/bin/arducopter -w --model=quad --home=51.423472000000004,-2.67141,0,180 --defaults /app/copter.parm --sysid=3
