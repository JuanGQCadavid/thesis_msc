# To debug

```bash
k logs -l app.kubernetes.io/name=reverse-proxy -n reverse-proxy -f
k logs -l app.kubernetes.io/name=db-api -n db-api  -f 
```