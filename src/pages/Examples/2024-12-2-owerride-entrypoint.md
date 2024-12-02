---
layout: default
title:  "Replace entropint in your container"
date:   2024-12-02 15:40:00 +0000
categories: examples
parent: Examples
nav_order: 1
---
Sometimes your container can fail to start and you need to troubleshoot it without running the entrypoint that fails and pod goes into endless Crashcrashloopbackoff.
Knowing that `command` field corresponds to `ENTRYPOINT`, and the `args` field corresponds to `CMD` update your container definition with the following:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: command-demo
  labels:
    purpose: demonstrate-command
spec:
  containers:
  - name: command-demo-container
    image: debian
    command: ["/bin/sh"]
    args: ["-c", "while true; do echo hello; sleep 10;done"]
  restartPolicy: OnFailure
```

After this container will start with endless while true loop and you can connect to it with the following command:
```bash
kubectl exec -it command-demo-66c7896cf6-fthdv bash
```