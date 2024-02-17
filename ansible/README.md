# Ansible

Note: This project is not meant to be run using the CLI. It is designed to be imported in ansible semaphore or ansible tower.

## How to install

```bash
# Either use the virtualenv
python3 -m virtualenv venv
source venv bin activate
pip install -r requirements.txt

# Or spawn a dev container
```

## How to run

- To run a playbook with vault password and become password:

```bash
anisble-playbook update.yaml -K --ask-vault-pass
```

- or without vault password:

```bash
ansible-playbook update.yaml 
```

## Description

- common.yaml: This playbook is used to install basic packages and configure the system.
- ssl.yaml: This playbook is used to install and configure ssl certificates.
