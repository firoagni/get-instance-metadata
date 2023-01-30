# get-instance-metadata

## Description
Shell script to query the metadata of a GCP instance and provide the output in JSON format

## Pre-requisites
- The script internally uses Google Cloud CLI to query. Therefore, for the script to work, ensure that gcloud CLI is installed and you are logged-in (or run via Cloudshell)

## Syntax 

```
./get_instace_metadata.sh -n <instance name> -p <project> -z <zone> -k <key>[-h]

options:
-n     Name of the instance
-p     GCP Project the instance belongs to
-z     Zone where the instance is hosted
-k     If a key is passed , the script returns the value of the provided key. Pass 'all' to returns all metadata
-h     Print help and exit.
```

## Examples

Print all metadata of instance `private-cluster-jumphost` hosted in zone `asia-south1-a` under project `a-demo-dev`
```
./get_instace_metadata.sh -n private-cluster-jumphost -p a-demo-dev -z asia-south1-a -k all
```

Print the value of the key `disks.architecture` of instance `private-cluster-jumphost` hosted in zone `asia-south1-a` under project `a-demo-dev`
```
./get_instace_metadata.sh -n private-cluster-jumphost -p a-demo-dev -z asia-south1-a -k disks.architecture
```