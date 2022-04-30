#!/bin/bash

hostname
service munge start
# TODO: slurmd does not start up correctly
# execute a shell in the container with "slurmd -Dvvv" for more details
service slurmd restart
sleep infinity