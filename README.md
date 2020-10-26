```docker-compose up --scale copter=9```

```docker run -e SITL_EXE=arduplane -e SITL_OPTS='--model=plane --defaults=/home/pilot/ardupilot/Tools/autotest/default_params/plane.parm' arthurrichards77/ardupilot-base:latest```

```docker-compose -f docker-compose.planes.yml up --scale plane=5```

```docker-compose -f docker-compose.mix.yml up --scale plane=3 --scale copter=4```

