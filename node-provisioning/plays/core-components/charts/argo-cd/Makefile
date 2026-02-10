upgrade:
	helm repo add argo-cd https://argoproj.github.io/argo-helm
	helm dep update .
	helm upgrade argocd . \
	  -n argocd \
	  -f values.yaml \
	  -f base.values.yaml