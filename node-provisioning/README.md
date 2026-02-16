# Ansible commands

## Inventory

```
# List
ansible-inventory -i inventory.ini --list

# Validate it 
ansible myhosts -m ping -i inventory.ini

# Run a playbook
ansible-playbook set-up-worker.yml
```

Configure vars for worker

```
# get the token for the cluster
# Run this on a cp node
kubeadm token create --print-join-command
```