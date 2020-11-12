# Ardupilot SITL Docker

(Yet another) container for Ardupilot Software-in-the-Loop simulation.  This one targets multi-vehicle simulation by exploiting the new (Oct 2020) capability in [Ardupilot](https://github.com/ArduPilot/ardupilot) to set the System ID via the command line.  Details are in [this commit](https://github.com/ArduPilot/ardupilot/commit/466a430c4f19cc9e18c36e8f1e6a558d5f1f64f8).

## Copter Simulation (Default Behaviour)

By default, the container launches a copter SITL instance plus an accompanying Mavproxy.py instance, which forwards the Mavlink stream to a common UDP port.  The copter will get its system ID from the last number of its Docker IP address, ensuring unique identities.  By default, that port is 14553 on the gateway.  Hence the following runs a single SITL:

```docker run arthurrichards77/ardupilot-sitl-docker:latest```

Then connect your multi-UAV-capable ground station as a listener to udp:localhost:14553 and you should get the data.  Repeat the ```docker run``` command and you should see more copters appear on your GCS.  I've tested using [QGroundControl](http://qgroundcontrol.com/).

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

```docker-compose.gateway.udp.yml``` provides an additional MAVProxy service to route all MAVLINK to a common UDP port, 14554, which is exposed to the outside world from Docker.  Connect your GCS as a UDP client to this port.

| An experimental ```docker-compose.gateway.yml``` provides an additional MAVProxy service to route all MAVLINK to a TCP server.  I thought this would be an easier way to connect than intercepting UDP streams, especially for ambitions to run this in the cloud.  However, it has extreme latency problems, to the point of beng unusable.
| Also ```docker-compose.gateway.pull.yml``` pulls the image from Docker hub instead of building it locally.

## Examples

Different GCS software appears to have different quirks regarding types of network connections.  These are the combinations I've got working.

### Mission Planner on Windows

Installation instructions for Docker on Windows can be found [here](https://docs.docker.com/docker-for-windows/install/).  It's a little fiddly to get the Hyper-V stuff right and will demand a restart.

Use the UDP gateway stack and launch via ```docker-compose -f docker-compose.gateway.udp.yml up --scale copter=3```.  Open the Docker Desktop and the Containers/Apps screen should show as below, if you click on the expanding arrow next to ardupilot-sitl-docker.  You can explore the resources and output of each element by clicking on its name.

![Docker screenshot](docker_win_screen.png)

Then fire up Mission Planner, select UDPCl (UDP client) as the connection type at top right, and hit connect.  Enter 127.0.0.1 as host and 14554 as port number.  It is rather slow to get going as downloading three sets of params takes on the order of a minute.  You should see three copters as below.

![Mission planner startup screenshot](mission_planner_start.png)

You can fly the drones around by hand, using Guided mode.  Use the drop-down box at the top right to choose which drone you're talking to.  It's rather slow - be prepared to have to repeat commands.

| TODO: investigate reducing data rate and using alternative MAVLINK gateways such as [mavp2p](https://github.com/aler9/mavp2p) or [MAVLink router](https://github.com/intel/mavlink-router).


### QGroundControl on Linux

I was using Ubuntu 18.04 and the latest QGC as of November 2020.

Use the default stack without the gateway: ```docker-compose up --scale copter=9```

The launch QGC and add a connection on UDP listening to port 14553.  You should see nine drones in different places.  Select "Multi-UAV" in QGC using the radio button at top right and you should see nine little info screens.  You can choose which drone to control using the drop-down at top centre.

| The combination of Linux and QGC seems to allow the UDP stream to be picked up outside Docker.  I couldn't reproduce this on Windows or Mission Planner so it should be regarded as brittle.

| TODO: screenshots for Linux

###

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
