---
layout: default
title:  "Connect to service ClusterIP"
date:   2024-12-02 15:40:00 +0000
categories: examples
parent: Examples
nav_order: 1
---
Let's say you have the service with type = ClusterIP and you need to connect to it from local PC. In this case you can forward the port using kubectl and access the service in your browser on localhost:local_port
```bash
kubectl port-forward service/service-name local_port:remote_port
```

[(C) Origin](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/)