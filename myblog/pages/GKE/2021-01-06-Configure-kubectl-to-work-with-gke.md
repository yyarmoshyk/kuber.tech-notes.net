---
layout: default
title:  "Configure Kubectl to work with AWS GKE"
date:   2019-09-10 16:06:00 +0000
categories: GKE
tags:
  - Kubectl
  - AWS
parent: GKE
---
This note contains the steps that need to be taken to configure your local kubectl to work with Kubernetes clusters running in Google GKE.

The steps are very simple. 
1. First you'll need to have the [Google Cloud SDK installed](https://cloud.google.com/sdk/docs/install)
1. Next you'll need to [authorize in your Google cloud account](https://cloud.google.com/sdk/docs/authorizing#running_gcloud_init)
```bash
gcloud init
```
You'll be asked for a number of questions. Type 74 if you'd like to skip zone config and move on to region selection.
1.Now you can run the following command to add the desired cluster into kubectl config:
```bash
gcloud container clusters get-credentials <cluster_name>
```
Sample output is the following:
```bash
Fetching cluster endpoint and auth data.
kubeconfig entry generated for <cluster_name>.
```
1. Verify the configuration
```bash
kubectl get svc
```

If you are adding multiple clusters, than you'll have multiple contexts configured. The default will be the last added. Run the following command to list contexts:
```bash
kubectl config get-contexts
```
You'll see the list of contexts. You can use the following to switch between them:
```bash
kubectl config use-context <name_of_the_context>
```

Now you can list the nodes, pods, etc:
```bash
kubectl get nodes
kubectl get pods
kubectl get services
```
