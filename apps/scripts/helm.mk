APP?="demo"

install:
	helm install ${APP} . -f values.yaml -f base.values.yaml -n ${APP} --create-namespace

update:
	helm upgrade ${APP} . -f values.yaml -f base.values.yaml -n ${APP} --create-namespace

template:
	helm template ${APP} . -f values.yaml -f base.values.yaml -n ${APP} --create-namespace