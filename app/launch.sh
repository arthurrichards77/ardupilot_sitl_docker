#!/bin/bash
SYSID=$(ip a | grep -o -m 1 172.[0123456789]*.0.[0123456789]* | grep -o [0123456789]*$)
echo "LAUNCH.SH: System ID will be $SYSID"
STARTPOSE=$(tail -n +$SYSID /home/pilot/app/starts.txt | head -n 1)
echo "LAUNCH.SH: Start location will be $STARTPOSE"
/home/pilot/ardupilot/build/sitl/bin/arducopter --sysid=$SYSID --home=$STARTPOSE  --model=quad --defaults=/home/pilot/ardupilot/Tools/autotest/default_params/copter.parm &
GATEWAY_IP=$(ip r | grep -m 1 default | grep -o [123456789][1234567890]*[.][1234567890]*[.][1234567890]*[.][1234567890]*)
echo "LAUNCH.SH: Gateway IP is $GATEWAY_IP"
mavproxy.py --non-interactive --target-system=$SYSID --master=tcp:0.0.0.0:5760 --out=udp:$GATEWAY_IP:14553
