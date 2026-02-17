

```
# Install repo - it is like telling helm where to find more charts
helm repo add bitnami https://charts.bitnami.com/bitnami    


# See which apps lives on that repo 
helm search repo bitnami

# Lets pick one of the charts on the repo 
helm repo update  # firts lets update the links
helm install bitnami/mysql --generate-name # Install it please on my repo


# Scan the chart
helm show chart bitnami/mysql

helm show all bitnami/mysql

# Uninstall 
helm uninstall mysql-1612624192
```