# CICD

This folder contains flux configuration for the production cluster and fleet configuration for the staging cluster.

## Directory Structure

```shell
cicd
├── README.md
├── manifests - Flux configuration for the production cluster
└── prod - Production cluster configuration, which uses the manifests
```

## Production Cluster

The production cluster is managed by [Flux](https://fluxcd.io/). The repository is broken into core, configs, controllers, and apps. The core directory contains the base configuration for the cluster.
