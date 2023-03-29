---
layout: default
title:  "Configuring access to Pods"
date:   2019-09-16 16:24:00 +0000
categories: cli
parent: Kubernetes overview
nav_order: 4
---
To make an app publicly available to the internet, you must update your configuration file before you deploy the app into a cluster. Different ways exist to make your app accessible from the internet:
  * `NodePort`: Expose a public port on every worker node and use the public IP address of any worker node to publicly access your service in the cluster.
  * `LoadBalancer`: Create an external TCP/ UDP load balancer for your app.
  * `Ingress`: Expose multiple apps in your cluster by creating one external HTTP or HTTPS load balancer that uses a secured and unique public entry point to route incoming requests to your apps.

You can use the `NodePort` Service to expose a public port on a worker node and use the public IP address to access your Service in the cluster. `NodePort` can be used for development, but is not recommended for production.

You can use the `NodePort` service for testing the public access for your app, or when public access is needed for a short amount of time. The public IP address of the worker Node is not permanent. When a worker Node is removed or re-created, a new public IP address is assigned to the worker Node. When you require a stable public IP address and more availability for your Service endpoint, you must use the `LoadBalancer` Service or `Ingress`.

## Using NodePort
To use the NodePort Service, define a `Service section` in the configuration file. In the spec section for the service, add the NodePort type.

```yaml
spec:
  type: NodePort
```
Optionally, in the ports section, add a `NodePort` in the `30000 - 32767` range.
```yaml
ports:
  - port: 80
    nodePort: 31514
```
Do not specify a `NodePort` that is already in use by another Service. If you are unsure which `NodePorts` are already in use, do not assign one. If no `NodePort` is assigned, a random one is assigned for you. When the app is deployed, you can use the public IP address of any worker Node and the NodePort to form the public URL to access the app in a browser.

If a random `NodePort` was assigned, you can find out what it is by using the following command, and specify the Service name with the command:
```bash
kubectl describe service
```

For information on how to configure the LoadBalancer service and Ingress controller, see the [Kubernetes Documentation](https://kubernetes.io/docs/home/).
