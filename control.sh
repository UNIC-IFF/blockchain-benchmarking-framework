#!/bin/bash

DEFAULT_ENVFILE="$(dirname $0)/defaults.env"
ENVFILE=${ENVFILE:-"$DEFAULT_ENVFILE"}
### Define or load default variables
source $ENVFILE
###

### Source scripts under scripts directory
. $(dirname $0)/scripts/helper_functions.sh
###

NETWORKS_ROOT_DIR=${NETWORKS_ROOT_DIR:-"$(realpath ./networks)"}
USAGE="$(basename $0) is the main control script for the Blockchain Benchmarking Framework.
Usage : $(basename $0) <network-type> <action> <arguments>

Network types:
  --list-network-types|-list
       Prints a list of the supported  network types
  --all|-a
       Runs the action for the  network of each supported type for the given arguments
  <network-type>
       Runs the action for the given network type. If there is no such type, it exits with error.
  --monitoring-stack|-mon <name of mon stack> 
       Starts the monitoring stack
Actions:
  start     --val-num|-n <num of validators>
       Starts a network with <num_validators> 
  configure --val-num|-n <num of validators>
       configures a network with <num_validators> 
  stop
       Stops the running networks
  clean
       Cleans up the configuration directories of the networks
  status
       Prints the status of the networks
        "

function help()
{
  echo "$USAGE"
}

function generate_network_configs()
{
  nvals=$1
  echo "Generating network configuration for $nvals validators..."
  echo "  done!"
}

function start_network()
{
  nvals=$1
  echo "Starting network with $nvals validators..."
  # TESTNET_NAME=$TESTNET_NAME docker-compose -f docker-compose-testnet.yml up -d
  echo "  network started!"
}

function control_monstack()
{
  monstack=$1
  echo "Control monitoring stack $1..."
  # TESTNET_NAME=$TESTNET_NAME docker-compose -f docker-compose-testnet.yml up -d
  ./monitoring-stacks/$monstack/control.sh $2
  #run_monitoring_services.sh 
}
function control_tgen()
{
  monstack=$1
  echo "Control traffic-generator $1..."
  # TESTNET_NAME=$TESTNET_NAME docker-compose -f docker-compose-testnet.yml up -d
  ./traffic-generators/$monstack/control.sh $2
  #run_monitoring_services.sh 
}

function control_scenario()
{
  monstack=$1
  echo "Control scenario $1..."
  # TESTNET_NAME=$TESTNET_NAME docker-compose -f docker-compose-testnet.yml up -d
  ./scemarios/$monstack/control.sh $2
  #run_monitoring_services.sh 
}

function stop_network()
{
  echo "Stopping network..."
  # TESTNET_NAME=$TESTNET_NAME docker-compose -f docker-compose-testnet.yml down
  echo "  stopped!"
}

function print_status()
{
  echo "Printing status of the  network..."
  # TESTNET_NAME=$TESTNET_NAME docker-compose -f docker-compose-testnet.yml status
  echo "  Finished!"
}

function do_cleanup()
{
  echo "Cleaning up network configuration..."
  # rm -rf ${DEPLOYMENT_DIR}/*
  echo "  clean up finished!"
}

function list_supported_networks()
{
  echo "List supported networks:"
  supported_nettypes=$(ls ${NETWORKS_ROOT_DIR})
  echo "${supported_nettypes[@]}"

}
ARGS="$@"

if [ $# -lt 1 ]
then
  #echo "No args"
  help
  exit 1
fi

while [ "$1" != "" ]; do
  case $1 in
    --all|-a ) shift
      echo "$@"
      exit
      while [ "$1" != "" ]; do
        case $1 in 
             -n|--val-num ) shift
               VAL_NUM=$1
               ;;
        esac
        shift
      done
      start_network $VAL_NUM
      exit
      ;;
    --monitoring-stack|-mon ) shift
      echo "$@"
      monstack_name=$1
      shift
      args="$@"
      control_monstack $monstack_name $args
      exit
      ;;
    --scenario|-sc ) shift
      echo "$@"
      scenario_name=$1
      shift
      args="$@"
      control_scenario $scenario_name $args
      exit
      ;;
    --traffic-generator|-tgen ) shift
      echo "$@"
      tgen_name=$1
      shift
      args="$@"
      control_tgen $tgen_name $args
      exit
      ;;
    --list-network-types|-list ) shift
      echo "$@"
      list_supported_networks
      exit
      ;;
    --list-monitoring-stacks|-list_mon ) shift
      echo "$@"
      list_supported_monstacks
      exit
      ;;
    --list-traffic-generators|-list_tgen ) shift
      echo "$@"
      list_supported_traffic_generators
      exit
      ;;
    --list-scenarios|-list_sc ) shift
      echo "$@"
      list_supported_scenarios
      exit
      ;;
    *) 
      network_type=$1
      shift
      rest_args="$@"
      echo $network_type $rest_args
      ${NETWORKS_ROOT_DIR}/$network_type/control.sh ${rest_args}
      exit
      ;;
  esac
  shift
done
