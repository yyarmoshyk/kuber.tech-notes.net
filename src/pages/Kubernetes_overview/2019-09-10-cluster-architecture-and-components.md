---
layout: default
title:  "Kubernetes cluster components"
date:   2019-09-10 16:06:00 +0000
categories: cli
parent: Kubernetes overview
nav_order: 1
---
<center><img src="/images/kubernetes_architecture.png"></center>

### Cluster
A cluster consists of one or more virtual machines that are called worker nodes. Each worker node represents a compute host where you can deploy, run, and manage containerized applications. Worker nodes are managed by a Kubernetes master node that controls and monitors all Kubernetes resources in the cluster.

### Scheduler
A kube-scheduler process runs on the master node and determines where (on which worker nodes) to assign new pods to run.

### Kubectl
You can use the command-line interface kubectl commands to interact with a Kubernetes cluster through the Kubernetes API.

### Kubernetes API
A kube-apiserver process runs on the master node in the cluster, and exposes the Kubernetes API.

### Etcd
Kubernetes stores cluster data in a backing store called etcd on the master node.

### kubelet
A kubelet is an agent that runs on each node in the cluster, communicates with the master, and manages activities and resources on the node, such as running Pod containers via Docker.

### Kube-proxy
Another process that runs on a node, called a kube-proxy, maintains network rules on the host and performs connection forwarding.

### Deployment
You can create a Deployment YAML file to tell Kubernetes how to deploy and manage application instances on the cluster. In this script, you can specify the container configuration and other Kubernetes resources that are required to run the application, such as persistent storage, services, and annotations. You can also create a deployment by using kubectl commands.

### Pod
A Pod can include one or more application containers and some shared resources, such as storage, networking information, and so on. The containers in a Pod share an IP Address and port space, are always co-located and co-scheduled, and run in a shared context on the same node.

Pods represent the smallest deployable units in a Kubernetes Cluster and are used to group containers to be treated as a single unit. Typically, a container is deployed to its own Pod, but an application might require other helper containers to be deployed into the Pod so that those containers can be addressed by using the same IP address.

### Controller
A set of controllers, which run as background threads on the master node, manage routine tasks in the cluster. For example, the node controller monitors the status of nodes, and responds when one goes down. There is also a replication controller for maintaining the correct number of Pods for a deployment, an endpoint controller for connecting services with Pods, and others. These controllers are compiled into a single binary process called kube-controller-manager.

### Service
A Service is an abstraction that defines a set of Pods, and a policy by which to access them. Kubernetes assigns each Service a "cluster IP" address, and the kube-proxy uses that address to direct traffic on the node.

<center><img src="/images/kubernetes_architecture2.png"></center>
