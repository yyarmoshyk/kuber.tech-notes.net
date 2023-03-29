---
layout: default
title:  "Configure Kubectl to work with AWS EKS"
date:   2019-09-10 16:06:00 +0000
categories: EKS
tags:
  - Kubectl
  - AWS
parent: EKS
---
This note contains the steps that need to be taken to configure your local kubectl to work with Kubernetes clusters running in AWS EKS.

The steps are very simple. Please note that this example assumes that you have multiple AWS profiles configured in the `~/.aws/config` and `~/.aws/credentials` files. If there is only default profile than there is no need to provide the `profile-name` as an argument to the aws cli command
1. List clusters available
```bash
aws eks list-clusters --profile profile-name
```
The sample output is the following:
```json
{
    "clusters": [
        "Cluster-Name-1",
        "Cluster-Name-2",
        "Cluster-Name-3"
    ]
}
```
1. Run the following to update the local `kubeconfig` specifying the AWS region, profile and the name of the cluster.
```bash
aws eks --region aws-region-name --profile profile-name update-kubeconfig --name Cluster-Name-1
aws eks --region aws-region-name --profile profile-name update-kubeconfig --name Cluster-Name-2
```
Sample output is the following:
```bash
Added new context arn:aws:eks:aws-region:12345678:cluster/Cluster-Name-1 to /Users/username/.kube/config
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
kubectl config use-context arn:aws:eks:aws-region:12345678:cluster/Cluster-Name-1
```

Now you can list the nodes, pods, etc:
```bash
kubectl get nodes
kubectl get pods
kubectl get services
```
