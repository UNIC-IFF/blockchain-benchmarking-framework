# Blockchain Benchmarking Framework
Backbone scripts and configuration for Blockchain Benchmarking Framework.

## Add a non-existing repo
```
*prepare_network_plugin.sh* prepares the files for the testnet plugin.
It adds the testnet as submodule to the existing repository and checks it out to the correct branch/tag.
Usage : prepare_network_plugin.sh <preparation type> <name>
Actions:
  network    <network-name> --git-url|-u <giturl> --git-branch|-b <gitbranch>
       Sets up the network plugin. --git-url and --git-branch are optional for external networks plugins. 
  traffic_generator  <name> --git-url <giturl>  --git-branch|-b <gitbranch>
       Sets up the traffic generator plugin. --git-url and --git-branch are optional for external traffic generator plugins. 
  scenario  <name> --git-url <giturl>  --git-branch|-b <gitbranch>
       Sets up the scenario plugin. --git-url and --git-branch are optional for external scenario plugins. 
  monitoring_stack  <name> --git-url <giturl>  --git-branch|-b <gitbranch>
       Sets up the monitoring_stack plugin. --git-url and --git-branch are optional for external monitoring_stack plugins. 
  show_known_networks
  show_known_traffic_generators
  show_known_monitoring_stacks
  show_known_scenarios
       Displays a list of known networks/traffic_generators/monitoring_stacks/scenarios
```

## Using the framework
*control.sh* script is used to control the networks.
```
```

# Authors/Contributors
* Antonios Inglezakis (@antiggl) [ inglezakis.a@unic.ac.cy ]
* Marios Touloupou (@mtouloup) [ touloupos.m@unic.ac.cy ]

