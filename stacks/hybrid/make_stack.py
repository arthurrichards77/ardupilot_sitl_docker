import yaml

num_copters = 4
print(f'Making stack for {num_copters} copters and one quadplane...')

compose_dict = {"version": "3.8",
                "services":
                    {"mavgw":{"image":"mickeyli789/mavlink-router",
                              "volumes":["./app:/app"],
                              "depends_on":[f'copter_{i+1}' for i in range(num_copters)] + [f'quadplane_{num_copters+1}'],
                              "entrypoint": f"sh /app/gw_launch_{num_copters}.sh",
                              "ports":["5760:5760"]}
                    }
                }

router_cmds = ['/mavlink-router/mavlink-routerd -c NULL']
router_cmds += [f"-p $(sh /app/get_host_ip.sh copter_{i+1}):5760" for i in range(num_copters)]                                    
router_cmds += [f"-p $(sh /app/get_host_ip.sh quadplane_{num_copters+1}):5760"]                                    
with open(f'app/gw_launch_{num_copters}.sh', 'w', newline="\n", encoding='utf8') as file:
    file.write("#!/bin/sh\n")
    file.write(' '.join(router_cmds))


for i in range(num_copters):
    lat = 51.423422+0.000025*i
    lon = -2.671610+0.0001*i
    hdg = 180
    compose_dict['services'][f'copter_{i+1}'] = {"image": "murphy360/ardupilot-sitl-copter",
                                                 "volumes":["./app:/app"],
                                                 "entrypoint": f"sh /app/copter_{i+1}.sh"}
    with open(f'app/copter_{i+1}.sh', 'w', newline="\n", encoding='utf8') as file:
        file.write("#!/bin/sh\n")
        file.write(f"mkdir -p /app/copter_{i+1}\n")
        file.write(f"cd /app/copter_{i+1}\n")
        file.write(f"/ardupilot/build/sitl/bin/arducopter -w --model=quad --home={lat},{lon},0,{hdg} --defaults /ardupilot/Tools/autotest/default_params/copter.parm --sysid={i+1}\n")


# last one is the quadplane
i = num_copters
lat = 51.423422+0.000025*i
lon = -2.671610+0.0001*i
hdg = 180
compose_dict['services'][f'quadplane_{i+1}'] = {"image": "murphy360/ardupilot-sitl-copter",
                                                "volumes":["./app:/app"],
                                                "entrypoint": f"sh /app/quadplane_{i+1}.sh"}
with open(f'app/quadplane_{i+1}.sh', 'w', newline="\n", encoding='utf8') as file:
    file.write("#!/bin/sh\n")
    file.write(f"mkdir -p /app/quadplane_{i+1}\n")
    file.write(f"cd /app/quadplane_{i+1}\n")
    file.write(f"/ardupilot/build/sitl/bin/arduplane -w --model=quadplane --home={lat},{lon},0,{hdg} --defaults /ardupilot/Tools/autotest/default_params/quadplane.parm --sysid={i+1}\n")


with open(f'docker-compose-{num_copters}.yml', 'w', encoding='utf8') as file:
    yaml.dump(compose_dict, file)

print('To run type:')
print(f'docker-compose -f docker-compose-{num_copters}.yml up')
print('or in swarm mode:')
print(f'docker stack deploy --compose-file docker-compose-{num_copters}.yml hybrid_{num_copters}')
