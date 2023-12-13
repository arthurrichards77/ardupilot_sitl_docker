# Ardupilot SITL Docker

## Usage

Docker stacks for Ardupilot SITL multi-drone simulation.

Run `cd stacks` and then `python make_stack -n <num-of-copters>`.

You should then see `docker-compose-<num-of-copters>.yml` created in the stacks directory.  Run `docker-compose -f docker-compose-<num-of-copters>.yml up` to start your cloud of simulators.  Connect your favourite ground control software to `tcp:localhost:5760` and you should see a long line of drones!

## About

This package has been heavily rationalized to make use of off-the-shelf images from Docker hub, avoiding custom builds and DOCKERFILEs.  This intends to enable swarm simulation deployment without having to maintain local registry data.

Each stack launches a number of [SITL instances](https://hub.docker.com/repository/docker/murphy360/ardupilot-sitl-copter) each with its own system ID.  The stack also includes a single [Mavlink router instance](https://hub.docker.com/r/mickeyli789/mavlink-router) configured to connect to each of the SITL instances and channel the MAVLINK data to en exposed port 5760.
