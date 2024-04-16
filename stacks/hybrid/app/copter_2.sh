#!/bin/sh
mkdir -p /app/copter_2
cd /app/copter_2
/ardupilot/build/sitl/bin/arducopter -w --model=quad --home=51.423472,-2.671310,0,180 --defaults /ardupilot/Tools/autotest/default_params/copter.parm --sysid=2
