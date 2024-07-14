#/bin/bash

# Use the docker user
sudo su docker
cd $HOME

# install the gitlab-runner
docker run -d --name gitlab-runner --restart always \
    -v $HOME/apps/gitlab-runner/config/config.toml:/etc/gitlab-runner/config.toml \
    -v $HOME/apps/gitlab-runner/certs:/etc/gitlab-runner/certs \
    -v /run/user/$(id -u)/docker.sock:/var/run/docker.sock \
    --env TZ=Europe/Berlin \
    gitlab/gitlab-runner:latest