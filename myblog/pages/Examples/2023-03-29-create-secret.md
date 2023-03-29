---
layout: default
title:  "Create kubernetes secret"
date:   2019-09-16 15:40:00 +0000
categories: examples
parent: Examples
nav_order: 1
---
Short note about creating the secret in kubernetes.

First you got to encode the text
```bash
echo sample-secret |base64
```

Next create the file with the following contexts:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret-name
type: Opaque
data:
  secret-key1: c2FtcGxlLXNlY3JldAo=
  secret-key2: c2FtcGxlLXNlY3JldAo=
  secret-key2: c2FtcGxlLXNlY3JldAo=
```

Next run kubectl to apply the change:
```bash
kubectl apply -f secret.yaml
```