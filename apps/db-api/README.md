## WARNING

This app uses a token header with _ . this is not acceptable by default for ngix controller,
in order to allow Nginx to accept it we should modified the controller by uopdating its configmap 

```
k edit cm ingress-nginx-controller
```

Then add the next data:

```
data:
  enable-underscores-in-headers: "true"
  ignore-invalid-headers: "false"
```

More configurations can be located at:
https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#ignore-invalid-headers