APP?="argo-apps"

install:
	helm install ${APP} . -f values.yaml -n argocd --create-namespace

upgrade:
	helm upgrade ${APP} . -f values.yaml -n argocd --create-namespace

template:
	helm template ${APP} . -f values.yaml -n argocd --create-namespace

remove:
	helm uninstall ${app}