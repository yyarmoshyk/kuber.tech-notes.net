---
layout: default
title:  "Migrate SSL certificate from one Kubernetes cluster to another"
date:   2021-01-14 00:00:00 +0000
categories: examples
parent: Examples
nav_order: 7
---
In most cases certificates are managed with [letsencrypt controller](https://medium.com/cloud-prodigy/configure-letsencrypt-and-cert-manager-with-kubernetes-3156981960d9) but sometimes we might need to migrate SSL certificate from one cluster into another.

Certificates are stored in Kubernetes secrets. Cert-manager will pick up existing secrets instead of creating new ones, if the secret matches the ingress object.

So assuming that the ingress object looks the same on both clusters, and that the same namespace is used, copying the secret is as simple as this:

```bash
kubectl --context OLD_CLUSTER -n NAMESPACE get secret SECRET_NAME --output yaml \
  | kubectl --context NEW_CLUSTER -n NAMESPACE apply -f -
```

This requires your PC to be configured to work with both clusters.

Refference:
1. [stackoverflow](https://stackoverflow.com/questions/65302295/move-cert-manager-certificate-to-another-kubernetes-cluster)