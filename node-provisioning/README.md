# Ansible commands

## Inventory

```
# List
ansible-inventory -i inventory.ini --list

# Validate it 
ansible myhosts -m ping -i inventory.ini

# Run a playbook
```