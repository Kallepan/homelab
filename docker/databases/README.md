# What is this?

## Description

A simple docker-compose.yaml file containing redis, psql, neo4j and mongoDB. Furthermore, adminer is included to manage the databases.

## Setup

```bash
# set permissions
sudo chown db:db /srv/

# copy other files
scp -r -i ./ssh/homelab databases/* db@10.4.0.4:/srv/

# modify .env values
scp -i ./ssh/homelab .env.example db@10.4.0.4:/srv/.env
```