# Ardupilot SITL Docker

(Yet another) container for Ardupilot Software-in-the-Loop simulation.  This one targets multi-vehicle simulation by exploiting the new (Oct 2020) capability in [Ardupilot](https://github.com/ArduPilot/ardupilot) to set the System ID via the command line.  Details are in [this commit](https://github.com/ArduPilot/ardupilot/commit/466a430c4f19cc9e18c36e8f1e6a558d5f1f64f8).

## Copter Simulation (Default Behaviour)

By default, the container launches a copter SITL instance plus an accompanying Mavproxy.py instance, which forwards the Mavlink stream to a common UDP port.  The copter will get its system ID from the last number of its Docker IP address, ensuring unique identities.  By default, that port is 14553 on the gateway.  Hence the following runs a single SITL:

```docker run arthurrichards77/ardupilot-sitl-docker:latest```

Then connect your multi-UAV-capable ground station to udp:localhost:14553 and you should get the data.  Repeat the ```docker run``` command and you should see more copters appear on your GCS.  I've tested using [QGroundControl](http://qgroundcontrol.com/).

## Plane Simulation

The container enables some customization via environment variables, including the SITL executable and command line options.  For example, the following runs a plane simulation.

```docker run -e SITL_EXE=arduplane -e SITL_OPTS='--model=plane --defaults=/home/pilot/ardupilot/Tools/autotest/default_params/plane.parm' arthurrichards77/ardupilot-sitl-docker:latest```

## Scaling up

Several [docker-compose](https://docs.docker.com/compose/) files are provided to support scaling up simulations.  The default ```docker-compose.yml``` includes only copters, enabling the following as a way to launch multiple copters at once:

```docker-compose up --scale copter=9```

An alternative ```docker-compose.planes.yml``` enables multiple planes:

```docker-compose -f docker-compose.planes.yml up --scale plane=5```

A final ```docker-compose.mix.yml``` covers both at the same time.

```docker-compose -f docker-compose.mix.yml up --scale plane=3 --scale copter=4```

| QGroundControl will struggle with this, as it appears to assume all UAVs are of the same type.  For example, you'll only get Copter modes in the drop-down.

| An experimental ```docker-compose.gateway.yml``` provides an additional MAVProxy service to route all MAVLINK to a common TCP server connection.  I thought this would be an easier way to connect than intercepting UDP streams, especially for ambitions to run this in the cloud.  However, it has extreme latency problems, to the point of beng unusable.

## Environment Variable Reference

The default command of the container runs a [launch script](https://github.com/arthurrichards77/ardupilot_sitl_docker/blob/master/app/launch.sh) which employs environment variables to enable customization.  The full list of these is below, including their default settings.  Of course, everything can be customized by overriding the command via Docker.

* SYSID : the target system ID, i.e. ```--sysid``` of the drone in the range 1-255 : default is the last number of the IP address
* STARTPOSE : the ```--home``` location for the drone in format lat,lon,alt,yaw : default is line $SYSID from the file [app/starts.txt](https://github.com/arthurrichards77/ardupilot_sitl_docker/blob/master/app/starts.txt)
* SITL_EXE : the executable filename from Ardupilot's ```/build/sitl/bin``` folder : default is ```arducopter```
* SITL_OPTS : options for SITL besides ```--home``` and ```-sysid```: default is ```--model=quad --defaults=/home/pilot/ardupilot/Tools/autotest/default_params/copter.parm```
* MAVLINK_OUT : forwarding address for MAVLINK packets, in format of ```--out``` [option for MAVProxy](https://ardupilot.org/mavproxy/docs/getting_started/starting.html) : default is ```udp:$GATEWAY_IP:14553``` where ```$GATEWAY_IP``` is the address of the Docker network gateway to the host.

## Similar Work

(https://hub.docker.com/r/edrdo/ardupilot-sitl-docker) was the inspiration for this work

See also (https://hub.docker.com/r/radarku/ardupilot-sitl) and many more found by searching on Docker hub.
