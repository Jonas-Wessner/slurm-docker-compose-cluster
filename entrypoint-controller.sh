#!/bin/bash

hostname
service munge start
service slurmctld restart
sleep infinity