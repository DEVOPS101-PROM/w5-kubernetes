** G-cloud cluster create **
```
gcloud container clusters create my-cluster \
--region europe-north1 \
--num-nodes 2 \
--machine-type e2-small \
--disk-size 30GB \
--enable-autoscaling --min-nodes 2 --max-nodes 3 \
--zone europe-north1-c \
--tags=http-server,https-server \
--spot
```
*** Kubernetes secret for regisry
1. read -s PAT
2. kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io\
  --docker-username=Tirtxika \
  --docker-password=$PAT \
3. ghcr.io/devops101-prom/simple-version:v1.0.0

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
imagePullSecrets:
  - name: ghcr-secret
```
