#!/bin/bash

# run watchtower manually
docker run -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once