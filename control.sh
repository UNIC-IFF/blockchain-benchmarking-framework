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
    --list-network-types|-list ) shift
      echo "$@"
      list_supported_networks
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
