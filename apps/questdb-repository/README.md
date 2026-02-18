# First time?
k create namespace questdb
helm install questdb  . -n questdb -f values.yaml -f base.values.yaml

# knowing missing stuff
Warning:
fs.file-max limit is too low [current=524288, recommended=1048576]
https://questdb.com/docs/getting-started/capacity-planning/#maximum-open-files

Warning:
vm.max_map_count limit is too low [current=65530, recommended=1048576]
https://questdb.com/docs/getting-started/capacity-planning/#max-virtual-memory-areas-limit