#!/bin/bash

NETWORK_PLUGINS_INSTALLATION_DIRS=${NETWORKS_ROOT_DIR:-"$(dirname $0)/../networks/"}
KNOWN_PLUGINS_REGISTRY_FILE=${KNOWN_PLUGINS_REGISTRY_FILE:-"$(dirname $0)/../known_network_plugins.json"}


USAGE="$(basename $0) prepares the files for the testnet plugin.
It adds the testnet as submodule to the existing repository and checks it out to the correct branch/tag.
Usage : $(basename $0) <preparation type> <name>
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
        "

function help()
{
  echo "$USAGE"
}


function show_networks()
{
jq .networks $KNOWN_PLUGINS_REGISTRY_FILE

}
function show_traffic_generators()
{
jq .traffic_generators $KNOWN_PLUGINS_REGISTRY_FILE

}
function show_monitoring_stacks()
{
jq .monitoring_stacks $KNOWN_PLUGINS_REGISTRY_FILE

}
function show_scenarios()
{
jq .scenarios $KNOWN_PLUGINS_REGISTRY_FILE

}


function setup_network()
{
  network_name=$1
  giturl=$2
  gitbranch=$3
  if [ "$giturl" != "" ]; then
    neturl=$giturl
    repobranch=$gitbranch
  else
    neturl=$(jq -r '.networks | map(select(.name=="'$network_name'")) | .[0].repo_url '  $KNOWN_PLUGINS_REGISTRY_FILE )
    repobranch=$(jq -r '.networks | map(select(.name=="'$network_name'")) | .[0].branch '  $KNOWN_PLUGINS_REGISTRY_FILE )
  fi
  echo $neturl $repobranch
  git submodule add $neturl ${NETWORK_PLUGINS_INSTALLATION_DIRS}/$network_name
  if [ "$repobranch" != "" ]; then
    mpwd=`pwd`
    cd ${NETWORK_PLUGINS_INSTALLATION_DIRS}/$network_name
    git checkout $repobranch
    cd $mpwd
  fi
}

function setup_traffic_generator()
{
  tgen_name=$1
  giturl=$2
  gitbranch=$3
  if [ "$giturl" != "" ]; then
    neturl=$giturl
    repobranch=$gitbranch
  else
    neturl=$(jq -r '.traffic_generators | map(select(.name=="'$tgen_name'")) | .[0].repo_url '  $KNOWN_PLUGINS_REGISTRY_FILE )
    repobranch=$(jq -r '.traffic_generators | map(select(.name=="'$tgen_name'")) | .[0].branch '  $KNOWN_PLUGINS_REGISTRY_FILE )
  fi
  echo $neturl $repobranch
  git submodule add $neturl ${TRAFFICGEN_PLUGINS_INSTALLATION_DIRS}/$tgen_name
  if [ "$repobranch" != "" ]; then
    mpwd=`pwd`
    cd ${TRAFFICGEN_PLUGINS_INSTALLATION_DIRS}/$tgen_name
    git checkout $repobranch
    cd $mpwd
  fi
}


function setup_monitoring_stack()
{
  mon_name=$1
  giturl=$2
  gitbranch=$3
  if [ "$giturl" != "" ]; then
    neturl=$giturl
    repobranch=$gitbranch
  else
    neturl=$(jq -r '.monitoring_stacks | map(select(.name=="'$mon_name'")) | .[0].repo_url '  $KNOWN_PLUGINS_REGISTRY_FILE )
    repobranch=$(jq -r '.monitoring_stacks | map(select(.name=="'$mon_name'")) | .[0].branch '  $KNOWN_PLUGINS_REGISTRY_FILE )
  fi
  echo $neturl $repobranch
  git submodule add $neturl ${MONSTACK_PLUGINS_INSTALLATION_DIRS}/$mon_name
  if [ "$repobranch" != "" ]; then
    mpwd=`pwd`
    cd ${MONSTACK_PLUGINS_INSTALLATION_DIRS}/$mon_name
    git checkout $repobranch
    cd $mpwd
  fi
}

### Creates a submodule from the given scenario name and the repository
function setup_scenario()
{
  scenario_name=$1
  giturl=$2
  gitbranch=$3
  if [ "$giturl" != "" ]; then
    neturl=$giturl
    repobranch=$gitbranch
  else
    neturl=$(jq -r '.scenarios | map(select(.name=="'$scenario_name'")) | .[0].repo_url '  $KNOWN_PLUGINS_REGISTRY_FILE )
    repobranch=$(jq -r '.scenarios | map(select(.name=="'$scenario_name'")) | .[0].branch '  $KNOWN_PLUGINS_REGISTRY_FILE )
  fi
  echo $neturl $repobranch
  git submodule add $neturl ${SCENARIO_PLUGINS_INSTALLATION_DIRS}/$scenario_name
  if [ "$repobranch" != "" ]; then
    mpwd=`pwd`
    cd ${SCENARIO_PLUGINS_INSTALLATION_DIRS}/$scenario_name
    git checkout $repobranch
    cd $mpwd
  fi
}


### MAIN - Arguments parsing

ARGS="$@"

if [ $# -lt 1 ]
then
  #echo "No args"
  help
  exit 1
fi

while [ "$1" != "" ]; do
  case $1 in
    "network" ) shift
      while [ "$1" != "" ]; do
        case $1 in 
             -u|--git-url ) shift
               GIT_URL=$1
               echo $1
               ;;
             -b|--git-branch ) shift
               GIT_BRANCH=$1
               echo $1
               ;;
             * )
               netname=$1
               echo $1
               ;;
        esac
        shift
      done
#      echo $netname $GIT_URL $GIT_BRANCH
      setup_network $netname $GIT_URL $GIT_BRANCH
      exit
      ;;
    "scenario" ) shift
      while [ "$1" != "" ]; do
        case $1 in 
             -u|--git-url ) shift
               GIT_URL=$1
               echo $1
               ;;
             -b|--git-branch ) shift
               GIT_BRANCH=$1
               echo $1
               ;;
             * )
               netname=$1
               echo $1
               ;;
        esac
        shift
      done
#      echo $netname $GIT_URL $GIT_BRANCH
      setup_scenario $netname $GIT_URL $GIT_BRANCH
      exit
      ;;
    "traffic_generator" ) shift
      while [ "$1" != "" ]; do
        case $1 in 
             -u|--git-url ) shift
               GIT_URL=$1
               echo $1
               ;;
             -b|--git-branch ) shift
               GIT_BRANCH=$1
               echo $1
               ;;
             * )
               netname=$1
               echo $1
               ;;
        esac
        shift
      done
#      echo $netname $GIT_URL $GIT_BRANCH
      setup_traffic_generator $netname $GIT_URL $GIT_BRANCH
      exit
      ;;
    "monitoring_stack" ) shift
      while [ "$1" != "" ]; do
        case $1 in 
             -u|--git-url ) shift
               GIT_URL=$1
               echo $1
               ;;
             -b|--git-branch ) shift
               GIT_BRANCH=$1
               echo $1
               ;;
             * )
               netname=$1
               echo $1
               ;;
        esac
        shift
      done
#      echo $netname $GIT_URL $GIT_BRANCH
      setup_monitoring_stack $netname $GIT_URL $GIT_BRANCH
      exit
      ;;
    "show_known_scenarios" ) shift
      show_scenarios
      exit
      ;;
    "show_known_networks" ) shift
      show_networks
      exit
      ;;
    "show_known_traffic_generators" ) shift
      show_traffic_generators
      exit
      ;;
    "show_known_monitoring_stacks" ) shift
      show_monitoring_stacks
      exit
      ;;
    * )
      help
      exit
     ;;
  esac
  shift
done

