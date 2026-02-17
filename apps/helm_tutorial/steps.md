

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


Create a new helm project
```
helm create <name>

# Add the repos you need as dependencies
helm repo add questdb https://helm.questdb.io/

# Then we update the repos link
helm repo update

# Then we need to search on the repo the helm they are providing
helm search repo questdb

# In that place, located the app we need under NAME, , also CHART VERSION is needed.
# Then add to Chart.yaml the next block
dependencies:
  - name: questdb # The name founded on search operation
    version: 1.0.20 # Same here
    repository: https://helm.questdb.io/ # the repo link
    
# Now we can donwload the deps
helm dep uopdate . 

# We can get the dependecy env values by
helm show values argo/argo-cd  > values.yaml

# Time to deploy for first time!

kubectl get ns questdb || kubectl create namespace questdb
helm install questdb  . -n questdb 
```

