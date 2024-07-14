#!/bin/bash

# confirmation dialog
read -p "Are you sure you want to reset the PKI? (This will delete all files) [y/N] " -n 1 -r
echo # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Reset cancelled"
    exit 1
fi

# remove all files in the output directory
echo "Resetting PKI..."
rm -rf output