import yaml

num_copters = 5

compose_dict = {"version": "3.8",
                "services":
                    {"mavgw":{"image":"arthurrichards77/mavrouter:v1",
                              "volumes":["./app:/app"],
                              "depends_on":[f'copter_{i+1}' for i in range(num_copters)],
                              "command": "/app/gw_launch.sh",
                              "ports":["5760:5760"]}}}

for i in range(num_copters):
    compose_dict['services'][f'copter_{i+1}'] = {"image": "arthurrichards77/ardupilot-sitl-docker:v3",
                                                 "command": f"/home/pilot/ardupilot/build/sitl/bin/arducopter -w --model=quad --home=51.501592,-2.551791,0,180 --defaults /home/pilot/ardupilot/Tools/autotest/default_params/copter.parm --sysid={i+1}"}

with open('docker-compose.yml', 'w') as file:
    yaml.dump(compose_dict, file)

router_cmds = ['mavlink-routerd'] + [f"-p $(/app/get_host_ip.sh copter_{i+1}):5760" for i in range(num_copters)]                                    

with open(f'app/gw_launch.sh', 'w', newline="\n") as file:
    file.write("#!/bin/bash\n")
    file.write(' '.join(router_cmds))
