#!/bin/sh
mkdir -p /app/quadplane_3
cd /app/quadplane_3
/ardupilot/build/sitl/bin/arducopter -w --model=quad --home=51.501592,-2.551791,0,180 --defaults /ardupilot/Tools/autotest/default_params/copter.parm --sysid=3
