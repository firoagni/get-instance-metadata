#!/bin/bash

# ---------------------------------------------------------
#   Script to query the metadata of a GCP instance 
#   and provide json formatted output
# ---------------------------------------------------------

# declare and initialize values.
selfStr="$(basename $0)"
project=""
instance=""
zone=""
output=""
key=""


# print help instructions
print_help() {
   echo
   echo "Script to query the metadata of a GCP instance and provide output in JSON format"
   echo
   echo "Syntax: ./$selfStr -n <instance name> -p <project> -z <zone> -k <key>[-h]"
   echo "options:"
   echo "-n     Name of the instance"
   echo "-p     GCP Project the instance belongs to"
   echo "-z     Zone where the instance is hosted"
   echo "-k     If a key is passed , the script returns the value of the provided key. Pass 'all' to returns all metadata"
   echo "-h     Print help and exit."
   echo
   echo "Examples:"
   echo
   echo "Print all metadata of instance 'private-cluster-jumphost' hosted in zone 'asia-south1-a' under project 'a-demo-dev'"
   echo "./$selfStr -n private-cluster-jumphost -p a-demo-dev -z asia-south1-a -k all"
   echo
   echo "Print the value of the key 'disks.architecture' of instance 'private-cluster-jumphost' hosted in zone 'asia-south1-a' under project 'a-demo-dev':"
   echo "./$selfStr -n private-cluster-jumphost -p a-demo-dev -z asia-south1-a -k disks.architecture"
   echo
   echo "Note:"
   echo "The script uses gcloud commands to query. Therefore, make sure that gcloud CLI is installed and you are logged-in"
}

# Bash's in-built getopts function to get values from flags
while getopts n:p:z:k:h flag  # If a character is followed by a colon (e.g. P:), that option is expected to have an argument.
do
    case "${flag}" in
      n) instance="$OPTARG";;
      p) project="$OPTARG";;
      z) zone="$OPTARG";;
      k) key="$OPTARG";;
      h) print_help
         exit 0
        ;;
      *) print_help
         exit 1
        ;;
    esac
done


# Function to print error message and exit
# $1 = message
printErrMsgAndExit() {
	echo -e "ERROR: $1"
    print_help
	exit 254
}

# check required parameters
[[ -z "${instance}" ]] && printErrMsgAndExit "Instance name not provided"
[[ -z "${project}"  ]] && printErrMsgAndExit "project name not provided"
[[ -z "${zone}"     ]] && printErrMsgAndExit "Zone not provided"
[[ -z "${key}"     ]] && printErrMsgAndExit "key not provided. Please pass 'all' if you wish to get complete metadata"

#check if gcloud cli is installed
if ! x=$(gcloud -v > /dev/null 2>&1;); then
  printErrMsgAndExit "Missing gcloud CLI. The script uses gcloud commands to query. Please install gcloud CLI and try again. Also make sure you are logged-in"
fi

#check key parameter
if([[ "${key}" == "all" ]])  
then
    gcloud compute instances describe ${instance} --zone ${zone} --project ${project} --format=json 
else
    gcloud compute instances describe ${instance} --zone ${zone} --project ${project} --format="value[](${key})"
fi

# No need to handle errors as gcloud throws appropriate error message on its own
