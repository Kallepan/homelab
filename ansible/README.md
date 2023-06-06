# Ansible

## How to install

```bash
python3 -m virtualenv venv
source venv bin activate
pip install -r requirements.txt
```

## How to run

- To run a playbook with vault password and become password:

```bash
anisble-playbook test.yaml -K --ask-vault-pass
```

- or without vault password:

```bash
ansible-playbook test.yaml 
```
