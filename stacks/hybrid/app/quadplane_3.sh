#!/bin/sh
mkdir -p /app/quadplane_3
cd /app/quadplane_3
/ardupilot/build/sitl/bin/arduplane -w --model=quadplane --home=51.423522,-2.671010,0,180 --defaults /ardupilot/Tools/autotest/default_params/quadplane.parm --sysid=3
