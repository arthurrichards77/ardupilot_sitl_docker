#!/bin/sh
mkdir -p /app/copter_4
cd /app/copter_4
/ardupilot/build/sitl/bin/arducopter -w --model=quad --home=51.423497000000005,-2.6713099999999996,0,180 --defaults /app/copter.parm --sysid=4
