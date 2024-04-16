#!/bin/sh
mkdir -p /app/copter_1
cd /app/copter_1
/ardupilot/build/sitl/bin/arducopter -w --model=quad --home=51.423422,-2.671610,0,180 --defaults /ardupilot/Tools/autotest/default_params/copter.parm --sysid=1
