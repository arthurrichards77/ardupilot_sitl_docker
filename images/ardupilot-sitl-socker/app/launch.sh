#!/bin/bash

ip a
if [ -z "$SYSID" ]
then
  echo "LAUNCH.SH: taking SYSID from IP address"
  SYSID=$(ip a | grep -o -m 1 172.[0123456789]*.0.[0123456789]* | grep -o -m 1 [0123456789]*$)
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

# setting instance=2 removes port conflict with mavlink-routerd
echo "$0: /home/pilot/ardupilot/build/sitl/bin/$SITL_EXE --sysid=$SYSID  --instance=2 --home=$STARTPOSE $SITL_OPTS &"
/home/pilot/ardupilot/build/sitl/bin/$SITL_EXE --sysid=$SYSID --instance=2 --home=$STARTPOSE $SITL_OPTS &

if [ -z "$MAVLINK_IP" ]
then
  if [ -z "$MAVLINK_HOSTNAME" ]
  then
    echo "$0: Neither hostname or IP given for Mavlink: assuming loopback"
    export MAVLINK_IP="127.0.0.1"
  else
    echo "$0: looking up hostname $MAVLINK_HOSTNAME"
    export MAVLINK_IP=$(getent ahostsv4 $MAVLINK_HOSTNAME | head -1 | awk '{print $1}')
  fi
else
  echo "$0: using provided Mavlink IP address $MAVLINK_IP"
fi

if [ -z "$MAVLINK_PORT"]
then
  echo "Mavlink port not provided: assuming default"
  export MAVLINK_PORT="14553"
fi
echo "$0: Will send MAVLINK to UDP endpoint $MAVLINK_IP:$MAVLINK_PORT"

#echo "LAUNCH.SH: mavproxy.py --non-interactive --target-system=$SYSID --master=tcp:0.0.0.0:5760 --out=$MAVLINK_OUT"
#mavproxy.py --non-interactive --target-system=$SYSID --master=tcp:0.0.0.0:5760 --out=$MAVLINK_OUT

echo "$0: mavlink-routerd --tcp-endpoint 127.0.0.1:5780 -e $MAVLINK_IP:$MAVLINK_PORT"
mavlink-routerd --tcp-endpoint 127.0.0.1:5780 -e $MAVLINK_IP:$MAVLINK_PORT
