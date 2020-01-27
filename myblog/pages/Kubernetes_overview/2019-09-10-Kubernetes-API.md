---
layout: default
title:  "Kubernetes API"
date:   2019-09-10 16:47:00 +0000
categories: cli
parent: Kubernetes overview
nav_order: 3
---
### Kubernetes API
The Kubernetes API is the foundation of Kubernetes. All Kubernetes objects have an entry in the API.

Kubernetes components interact through the API server (`kube-apiserver`), which runs on the Master node, handles all operations and communication between components through REST API calls.

* The `kubectl` command-line tool can be used to create, update, delete, and get API objects.
* Kubernetes stores the state of configured resources in `etcd`.
* You can extend the Kubernetes API through the use of [custom resources](https://kubernetes.io/docs/concepts/api-extension/custom-resources/), and by using the [aggregation layer](https://kubernetes.io/docs/concepts/api-extension/apiserver-aggregation/).

For more information, see [https://kubernetes.io/docs/concepts/overview/kubernetes-api/](https://kubernetes.io/docs/concepts/overview/kubernetes-api/).

### Useful links:
* [API conventions document](https://git.k8s.io/community/contributors/devel/api-conventions.md): describes API conventions.
* [API reference document](https://kubernetes.io/docs/reference): describes API endpoints, resource types and samples.
* [Remote access document](https://kubernetes.io/docs/admin/accessing-the-api): describes how to access the API remotely.
* [Overview of kubectl commands](https://kubernetes.io/docs/user-guide/kubectl-overview/): covers syntax, describes command operations, and provides some examples.
