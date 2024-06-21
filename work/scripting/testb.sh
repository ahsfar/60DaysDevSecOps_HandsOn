#!/bin/bash

source="/home/ubuntu/Desktop/devops"
destination="/home/ubuntu/Desktop/backup"

rm -r $destination

echo "Cleared direcotry"

cp -r $source $destination

echo "Backup created in "$destination
