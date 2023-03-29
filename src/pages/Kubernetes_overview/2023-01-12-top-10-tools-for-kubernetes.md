---
layout: default
title:  "Top 10 tools to be used in Kubernetes"
date:   2023-01-12 16:47:00 +0000
categories: examples
parent: Examples
nav_order: 3
---
# CLI
## Develop applications
* [Rancher desktop](https://rancherdesktop.io/) based on k3s. It is the best way to run the local kubernetes environments
## Operate clusters
* kubectl is the default tool that can be extended by plugins
  * [ctx](https://github.com/weibeld/kubectl-ctx) - easily switch between contexts
  * [ns](https://github.com/postfinance/kubectl-ns) - simplifies switch etween namespaces
## Manage third party applications
* [helm](https://helm.sh/) to manage applications' deployment
## Observe what is going on in the cluster
* [k9s cli](http://k9scli.io) - good observer

# In clusters
## Syncronize desired state with the actual state
GitOps can be also achieved by pipelines.
Both of them are great. You'll just have process in your cluster and continiously monitor your git repository and whenever it detects the change in git repository, than it will update the state of your kubernetes resources
* [argocd](https://argoproj.github.io/cd/)
* [flux](https://fluxcd.io)
## Encryption
TLS certificates
* [cert-manager](https://cert-manager.io/) controller. Enables us to use letsencrypt to encrypt traffic with https
## Manage infra and apps
* [crossplane](https://www.crossplane.io/) allows to manage infrastructure the kubernetes way
* * [kubevela](https://kubevela.io/)
## Collect metrics, observe and alert
Seeing the statistics and what is going on
* prometheus to collect metrics + grafana to observe
## Collect logs
* [promtail](https://grafana.com/docs/loki/latest/clients/promtail/) - to collect logs
* [loki](https://github.com/grafana/loki) like Prometheus, but for logs - to store logs
## Policies
* [kyverno](https://kyverno.io)
* [open policy gatekeeper](https://open-policy-agent.github.io/gatekeeper)
