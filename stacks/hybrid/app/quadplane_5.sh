#!/bin/sh
mkdir -p /app/quadplane_5
cd /app/quadplane_5
/ardupilot/build/sitl/bin/arduplane -w --model=quadplane --home=51.423522000000006,-2.67121,0,180 --defaults /app/quadplane.parm --sysid=5
