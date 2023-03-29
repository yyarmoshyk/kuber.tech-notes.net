---
layout: default
title:  "Configuration file examples"
date:   2019-09-16 15:40:00 +0000
categories: examples
parent: Examples
nav_order: 1
---
A configuration file contains configuration details for each of the resources that you create in Kubernetes. After you create a Deployment configuration file, you can use either the Kubernetes CLI, or the GUI to run it, and deploy the resources that it defines (Pods, Services, and so on) to the cluster.

You will see some examples of these sections in the sample code that is used in this course. For complete details on everything that you can possibly do in a configuration file, see the Kubernetes documentation.

A configuration script can include one or more of the following sections:
  * Deployment: Defines the creation of pods and replica sets. A pod includes an individual containerized app, and replica sets control multiple instances of pods.
  * Service: Provides front-end access to pods by using a worker node or load balancer public IP address, or a public Ingress route.
  * Ingress: Specifies a type of load balancer that provides routes to access your app publicly.

## Simple Pod definition
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: samplepod
spec:
  containers:
  - name: samplepod
    image: sampleimage:1.0
    ports:
    - containerPort: 80
```

This example is a sample Pod definition that contains the minimum amount of information. It describes a single container named `samplepod`, based on the image named sampleimage:1.0, and assuming that the Pod IP is accessible, can be accessed on port 80.

## Volume definition
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: samplepod
spec:
  containers:
  - name: samplepod
    image: sampleimage:1.0
    volumeMounts:
    - name: sample-storage
      mountPath: /data/mount_path
    volumes:
    - name: sample-storage
      emptyDir: ()
```

For applications that require persistent storage, you can define a Volume. In this example, the Volume is named `sample-storage`, and the `mountPath` defines the path to mount the Volume within the container.

*emptyDir*: Creates a new directory that exists as long as the Pod is running on the Node, but it can persist across container failures and restarts.

## Multiple containers
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp
spec:
  containers:
  - name: web
    image: web:1.0
    volumeMounts:
    - mountPath: /var/www
      name: web-data
      readOnly: true
    ports:
    - containerPort: 80
  - name: monitor
    image: monitor
    env:
    - name: SOME_VARIABLE
      value: some_value
      volumeMounts:
      - mountPath: /data
        name: web-data
  volumes:
  - name: web-data
    emptyDir: ()
```
This example defines two containers: one for a web application named `web`, and another helper container named `monitor`. Each container defines its own Volume mount path, and they share a Volume named `web-data` with the Pod.

## Label definition
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: samplepod
  labels:
    app: sample
spec:
  containers:
  - name: samplepod
    image: sampleimage:1.0
    ports:
    - containerPort: 80
```
Labels are `key:value` pairs that can be used to organize and select Pods. You can assign labels to objects in Kubernetes, and then use a label selector to retrieve a list of objects that match a certain label. To add a label in a configuration file, add a `labels` section under `metadata` in the Pod definition, as shown in this example.

## Deployment configuration
```yaml
apiVersion: v1
kind: Deployment
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: sample
  spec:
    containers:
    - name: samplepod
      image: sampleimage:1.0
      ports:
      - containerPort: 80
```
A Deployment can define a set of Pods that can then be managed as a unit. In the configuration file, you can use a label selector to identify the Pods in the Deployment, and specify the number of replicas that you want Kubernetes to maintain. Kubernetes creates or deletes Pods as necessary to maintain the replica count. You can also use Deployments to manage rolling updates to your Pods.

## Service configuration
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  ports:
  - port: 8080
    targetPort: 80
    protocol: TCP
  selector:
    app: myapp
```
A Service provides a layer of abstraction to enable connectivity between the various layers of your application. You define a Service to refer to a set of Pods by using a single static IP address. That way, you don’t have to reconfigure parts of your application when ever you scale up or down.

The example here creates a Service named `my-service` that serves on port `8000` on the container for each Pod. This value can also be a string like www. The label selector identifies the set of Pods to load balance the traffic to.

## Health checks
### HTTP health check
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-http-health
spec:
  containers:
  - name: pod-http-health
    image: pod-http-health:1.0
    livenessProbe:
      httpGet:
        path: /health
        port: 80
      initialDelaySeconds: 30
      timeoutSeconds: 1
  ports:
  - containerPort: 80
```

### TCP health check
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-tcp-health
spec:
  containers:
  - name: pod-tcp-health
    image: pod-tcp-health:1.0
    livenessProbe:
        port: 8080
      initialDelaySeconds: 30
      timeoutSeconds: 1
  ports:
  - containerPort: 8080
```

By default, process health checking is always enabled. The kubelet periodically checks with the Docker daemon to make sure that the container is still running, and restarts the process if necessary. In addition to this low-level checking, you can also implement application-level health checking by adding a `livenessProbe` section to the container configuration. You can configure the livenessProbe to check the status of `HTTP`, the container, or `TCP`.

The example on the left defines an HTTP `livenessProbe` with an `initialDelaySeconds` of `30`, which is the grace period from when the container is started to when health checks are done, to enable the container to do any necessary initialization. The second example defines a TCP health check. Another example, not shown here, is where you can define a command to be run in the container, to check the container status.

You can find more details and examples in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/overview/).
