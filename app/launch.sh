#!/bin/bash

if [ -z "$SYSID" ]
then
  echo "LAUNCH.SH: taking SYSID from IP address"
  SYSID=$(ip a | grep -o -m 1 172.[0123456789]*.0.[0123456789]* | grep -o [0123456789]*$)
fi
echo "LAUNCH.SH: System ID will be $SYSID"

if [ -z "$STARTPOSE" ]
then
  echo "LAUNCH.SH: taking STARTPOSE from starts.txt file"
  STARTPOSE=$(tail -n +$SYSID /home/pilot/app/starts.txt | head -n 1)
fi
echo "LAUNCH.SH: Start location will be $STARTPOSE"

if [ -z "$SITL_EXE" ]
then
  SITL_EXE='arducopter'
fi

if [ -z "$SITL_OPTS" ]
then
  SITL_OPTS='--model=quad --defaults=/home/pilot/ardupilot/Tools/autotest/default_params/copter.parm'
fi

echo "LAUNCH.SH: /home/pilot/ardupilot/build/sitl/bin/$SITL_EXE --sysid=$SYSID --home=$STARTPOSE $SITL_OPTS &"
/home/pilot/ardupilot/build/sitl/bin/$SITL_EXE --sysid=$SYSID --home=$STARTPOSE $SITL_OPTS &

if [ -z "$MAVLINK_OUT" ]
then
  echo "LAUNCH.SH: sending MAVLINK output to gateway" 
  GATEWAY_IP=$(ip r | grep -m 1 default | grep -o [123456789][1234567890]*[.][1234567890]*[.][1234567890]*[.][1234567890]*)
  echo "LAUNCH.SH: Gateway IP is $GATEWAY_IP"
  MAVLINK_OUT="udp:$GATEWAY_IP:14553"
fi
echo "LAUNCH.SH: Will send MAVLINK to $MAVLINK_OUT"

echo "LAUNCH.SH: mavproxy.py --non-interactive --target-system=$SYSID --master=tcp:0.0.0.0:5760 --out=$MAVLINK_OUT"
mavproxy.py --non-interactive --target-system=$SYSID --master=tcp:0.0.0.0:5760 --out=$MAVLINK_OUT
