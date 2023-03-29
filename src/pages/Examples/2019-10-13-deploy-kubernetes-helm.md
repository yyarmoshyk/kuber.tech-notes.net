---
layout: default
title:  "Deploy, Scale and Upgrade an Application on Kubernetes with Helm"
date:   2019-09-16 15:40:00 +0000
categories: examples
parent: Examples
nav_order: 3
---
<h3 id="introduction">Introduction</h3>

Containers have revolutionized application development and delivery on account of their ease of use, portability and consistency. And when it comes to automatically deploying and managing containers in the cloud (public, private or hybrid), one of the most popular options today is <a href="https://kubernetes.io">Kubernetes</a>.

Kubernetes is an open source project designed specifically for container orchestration. Kubernetes offers a number of <a href="https://kubernetes.io/docs/whatisk8s/">key features</a>, including multiple storage APIs, container health checks, manual or automatic scaling, rolling upgrades and service discovery. Applications can be installed to a Kubernetes cluster via <a href="https://helm.sh/">Helm charts</a>, which provide streamlined package management functions.

If you’re new to Kubernetes and Helm charts, one of the easiest ways to discover their capabilities is with <a href="https://bitnami.com">Bitnami</a>. Bitnami offers a number of stable, production-ready <a href="https://bitnami.com/kubernetes">Helm charts</a> to deploy popular software applications, such as <a href="https://kubeapps.com/charts/stable/wordpress">WordPress</a>, <a href="https://kubeapps.com/charts/stable/magento">Magento</a>, <a href="https://kubeapps.com/charts/stable/redmine">Redmine</a> and <a href="https://kubeapps.com/charts/search?q=bitnami">many more</a>, in a Kubernetes cluster. Or, if you’re developing a custom application, it’s also possible to use Bitnami’s Helm charts to package and deploy it for Kubernetes.

This guide walks you through the process of bootstrapping an example MongoDB, Express, Angular and Node.js (MEAN) application on a Kubernetes cluster. It uses a custom Helm chart to create a Node.js and MongoDB environment and then clone and deploy a MEAN application from a public Github repository into that environment. Once the application is deployed and working, it also explores some of Kubernetes’ most interesting features: cluster scaling, load-balancing, and rolling updates.

<div name="assumptions-and-prerequisites" data-unique="assumptions-and-prerequisites"></div><h3 id="assumptions-and-prerequisites">Assumptions and Prerequisites</h3>

This guide focuses on deploying an example MEAN application in a Kubernetes cluster running on either Google Container Engine (GKE) or Minikube. The example application is <a href="https://github.com/scotch-io/node-todo">a single-page Node.js and Mongo-DB to-do application available on Github</a>.

This guide makes the following assumptions:

<ul>
<li>You have a Kubernetes 1.5.0 (or later) cluster.</li>
<li>You have `kubectl` installed and configured to work with your Kubernetes cluster.</li>
<li>You have `git` installed and configured.</li>
<li>You have a basic understanding of how containers work. Learn more about containers on  <a href="https://en.wikipedia.org/wiki/Operating-system-level_virtualization">Wikipedia</a> and on <a href="http://www.zdnet.com/article/containers-fundamental-to-the-evolution-of-the-cloud/">ZDNet</a>.</li>
</ul>

<blockquote class="note tip">
TIP: If you don’t already have a Kubernetes cluster, the easiest way to get one is via GKE or Minikube. For detailed instructions, refer to our <a href="https://docs.bitnami.com/kubernetes/get-started-kubernetes">starter tutorial</a>.

NOTE: GKE is recommended for production deployments because it is a production-ready environment with guaranteed uptime, load balancing and included container networking features. That said, the commands shown in this guide can be used on both GKE and Minikube. Commands specific to one or the other platform are explicitly called out as such.
</blockquote>

<div name="step-1-validate-the-kubernetes-cluster" data-unique="step-1-validate-the-kubernetes-cluster"></div><h3 id="step-1-validate-the-kubernetes-cluster">Step 1: Validate the Kubernetes cluster</h3>

First, ensure that you are able to connect to your cluster with `kubectl cluster-info`. This command is also a good way to get the IP address of your cluster.

```bash
kubectl cluster-info
```

You should see output similar to the following:

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-1.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-1.png" alt="Cluster information"></a>

This is also a good time to get some information about the physical nodes in the cluster with `kubectl get nodes`:

```bash
kubectl get nodes
```

Sample output is shown below:

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-2.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-2.png" alt="Cluster information"></a>

<blockquote class="tip">
TIP: For detailed cluster health and status, <a href="https://docs.bitnami.com/kubernetes/get-started-kubernetes/#step-6-access-kubernetes-dashboard">visit the Kubernetes dashboard</a>.
</blockquote>

<div name="step-2-install-helm-and-tiller" data-unique="step-2-install-helm-and-tiller"></div><h3 id="step-2-install-helm-and-tiller">Step 2: Install Helm and Tiller</h3>

To install Helm, execute these commands:

```bash
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
```

Once the installation process completes, install Helm’s server-side counterpart, Tiller, with the `helm init` command:

```bash
helm init
```

You should see something similar to the output below:

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-3.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-3.png" alt="Tiller installation"></a>

Check that Tiller is installed by checking the output of `kubectl get pods` as shown below:

```bash
kubectl --namespace kube-system get pods | grep tiller
```

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-4.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-4.png" alt="Tiller installation"></a>

<div name="step-3-deploy-the-example-application" data-unique="step-3-deploy-the-example-application"></div><h3 id="step-3-deploy-the-example-application">Step 3: Deploy the example application</h3>

The smallest deployable unit in Kubernetes is a “pod”. A pod consists of one or more containers which can communicate and share data with each other. Pods make it easy to scale applications: scale up by adding more pods, scale down by removing pods. <a href="https://kubernetes.io/docs/user-guide/pods/">Learn more about pods</a>.

The Helm chart used in this guide deploys the example to-do application as two pods: one for Node.js and the other for MongoDB. This is considered a best practice because it allows a clear separation of concerns, and it also allows the pods to be scaled independently (you’ll see this in the next section).

<blockquote class="note">
NOTE: The Helm chart used in this guide has been developed to showcase the capabilities of both Kubernetes and Helm, and has been tested to work with the example to-do application. It can be adapted to work with other MEAN applications, but it may require some changes to connect the MongoDB pod with the application pod.
</blockquote>

To deploy the sample application using a Helm chart, follow these steps:
1.	Clone the Helm chart from Bitnami’s Github repository:
```bash
git clone https://github.com/bitnami/charts.git
cd charts/incubator/mean
```
1.	Check for and install missing dependencies with `helm dep`. The Helm chart used in this example is dependent on the MongoDB chart in the official repository, so the commands below will take care of identifying and installing the missing dependency.
```bash
helm dep list
helm dep update
helm dep build
```
Here’s what you should see:
<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-5.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-5.png" alt="Dependency installation with Helm"></a>
1.	Lint the chart with `helm lint` to ensure it has no errors.
```bash
helm lint .
```
1.	Deploy the Helm chart with `helm install`. This will produce two pods (one for the Node.js service and the other for the MongoDB service). Pay special attention to the NOTES section of the output, as it contains important information to access the application.
> NOTE: If you don't specify a release name with the *
```bash
helm install . --name my-todo-app --set serviceType=LoadBalancer
```
You should see something like the output below as the chart is installed.
<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-6.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-6.png" alt="Application deployment with Helm"></a>
Unlike cloud platforms, Minikube doesn’t support a load balancer so, if you’re deploying the application on Minikube, use the command below instead:
```bash
helm install . --name my-todo-app --set serviceType=NodePort
```
You should see the output below as the chart is installed on Minikube.
<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-7.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-7.png" alt="Application deployment with Helm"></a>
1.	Get the URL for the Node application by executing the commands shown in the output of `helm install`, or by using `helm status my-todo-app` and checking the output for the external IP address.
If you deployed the application on GKE, use these commands to obtain the URL for the Node application:
```bash
export SERVICE_IP=$(kubectl get svc --namespace default my-todo-app-mean -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo http://$SERVICE_IP/
```
If you deployed the application on Minikube, use these commands instead to obtain the URL for the Node application:
```bash
export NODE_PORT=$(kubectl get --namespace default -o jsonpath="{.spec.ports[0].nodePort}" services my-todo-app-mean)
export NODE_IP=$(kubectl get nodes --namespace default -o jsonpath="{.items[0].status.addresses[0].address}")
echo http://$NODE_IP:$NODE_PORT/
```
1.	Browse to the specified URL and you should see the sample application running. Here’s what it should look like:
<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-8.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-8.png" alt="Application running in cluster"></a>
To debug and diagnose deployment problems, use `kubectl get pods -l app=my-todo-app-mean`. If you specified a different release name (or didn’t specify one), remember to use the actual release name from your deployment.
To delete and reinstall the Helm chart at any time, use the `helm delete` command, shown below. The additional `--purge` option removes the release name from the store so that it can be reused later.
```bash
helm delete --purge my-todo-app
```
<a name="step-4-explore-kubernetes-and-helm"></a>
<div name="step-4-explore-kubernetes-and-helm" data-unique="step-4-explore-kubernetes-and-helm"></div><h3 id="step-4-explore-kubernetes-and-helm">Step 4: Explore Kubernetes and Helm</h3>

<blockquote class="tip">
TIP: Once you’ve got your application running on Kubernetes, read our <a href="https://docs.bitnami.com/kubernetes/how-to/secure-wordpress-kubernetes-managed-database-ssl-upgrades">guide on performing more complex post-deployment tasks</a>, including setting up TLS with Let’s Encrypt certificates and performing rolling updates.
</blockquote>

<div name="scale-up-or-down" data-unique="scale-up-or-down"></div><h4 id="scale-up-or-down">Scale up (or down)</h4>

<blockquote class="note">
NOTE: For simplicity, this section focuses only on scaling the Node.js pod.
</blockquote>

As more and more users access your application, it becomes necessary to scale up in order to handle the increased load. Conversely, during periods of low demand, it often makes sense to scale down to optimize resource usage.

Kubernetes provides the `kubectl scale` command to scale the number of pods in a deployment up or down. <a href="https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#scale/">Learn more about the `kubectl scale` command</a>.

Verify the number of pods currently running for each service with the `helm status` command, as shown below:

```bash
helm status my-todo-app
```

The output should show you one running instance of each pod.

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-9.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-9.png" alt="Application status"></a>

Then, scale the Node.js pod up to three copies using the `kubectl scale` command below.

```bash
kubectl scale --replicas 3 deployment/my-todo-app-mean
```

Check the status as before to verify that you have three Node.js pods.

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-10.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-10.png" alt="Application status"></a>

Then, scale it back down to two using the command below:

```bash
kubectl scale --replicas 2 deployment/my-todo-app-mean
```

Check the status as before to verify that you have two Node.js pods.

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-11.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-11.png" alt="Application status"></a>

A key feature of Kubernetes is that it is a self-healing system: if one or more pods in a Kubernetes cluster are terminated unexpectedly, the cluster will automatically spin up replacements. This ensures that the required number of pods are always running at any given time.

To see this in action, use the `kubectl get pods` command to get a list of running pods, as shown below:

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-12.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-12.png" alt="Pod listing"></a>

As you can see, this cluster has been scaled up to have 2 Node.js pods. Now, select one of the Node.js pods and simulate a pod failure by deleting it with a command like the one below. Replace the POD-ID placeholder with an actual pod identifier from the output of the `kubectl get pods` command.

```bash
kubectl delete pod POD-ID
```

Now, run `kubectl get pods -w` again and you will see that Kubernetes has instantly replaced the failed pod with a new one:

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-13.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-13.png" alt="Cluster self-healing"></a>

If you keep watching the output of `kubectl get pods -w`, you will see the state of the new pod change rapidly from “Pending” to “Running”.

<div name="balance-traffic-between-pods" data-unique="balance-traffic-between-pods"></div><h4 id="balance-traffic-between-pods">Balance traffic between pods</h4>

It’s easy enough to spin up two (or more) replicas of the same pod, but how do you route traffic to them? When deploying an application to a Kubernetes cluster in the cloud, you have the option of automatically creating a cloud network load balancer (external to the Kubernetes cluster) to direct traffic between the pods. This load balancer is an example of a Kubernetes Service resource. <a href="https://kubernetes.io/docs/user-guide/services/">Learn more about services in Kubernetes</a>.

You’ve already seen a Kubernetes load balancer in action. When deploying the application to GKE with Helm, the command used the `serviceType` option to create an external load balancer, as shown below:

```bash
helm install . --name my-todo-app --set serviceType=LoadBalancer
```

When invoked in this way, Kubernetes will not only create an external load balancer, but will also take care of configuring the load balancer with the internal IP addresses of the pods, setting up firewall rules, and so on.
To see details of the load balancer service, use the `kubectl describe svc` command, as shown below:

```bash
kubectl describe svc my-todo-app
```

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-14.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-14.png" alt="Load balancer service description"></a>

Notice the `LoadBalancer Ingress` field, which specifies the IP address of the load balancer, and the `Endpoints` field, which specifies the internal IP addresses of the three Node.js pods in use. Similarly, the `Port` field specifies the port that the load balancer will listen to for connections (in this case, 80, the standard Web server port) and the `NodePort` field specifies the port on the internal cluster node that the pod is using to expose the service.

Obviously, this doesn’t work quite the same way on a Minikube cluster running locally. Look back at the Minikube deployment and you’ll see that the `serviceType` option was set to `NodePort`. This exposes the service on a specific port on every node in the cluster.

```bash
helm install . --name my-todo-app --set serviceType=NodePort
```

Verify this by checking the details of the service with `kubectl describe svc`:

```bash
kubectl describe svc my-todo-app
```

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-15.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-15.png" alt="NodePort service description"></a>

The main difference here is that instead of an external network load balancer service, Kubernetes creates a service that listens on each node for incoming requests and directs it to the static open port on each endpoint.

<a name="perform-rolling-updates-and-rollbacks"></a>

<div name="perform-rolling-updates-and-rollbacks" data-unique="perform-rolling-updates-and-rollbacks"></div><h4 id="perform-rolling-updates-and-rollbacks">Perform rolling updates (and rollbacks)</h4>

Rolling updates and rollbacks are important benefits of deploying applications into a Kubernetes cluster. With rolling updates, devops teams can perform zero-downtime application upgrades, which is an important consideration for production environments. By the same token, Kubernetes also supports rollbacks, which enable easy reversal to a previous version of an application without a service outage. <a href="https://kubernetes.io/docs/user-guide/rolling-updates/">Learn more about rolling updates</a>.

Helm makes it easy to upgrade applications with the `helm upgrade` command, as shown below:

```bash
helm upgrade my-todo-app .
```

Check upgrade status with the `helm history` command shown below:

```bash
helm history my-todo-app
```

Here’s what it looks like:

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-16.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-16.png" alt="NodePort service description"></a>

As shown in the output, the application has been upgraded and is now running revision #2.

When performing an upgrade, it is important to specify the same parameters as when the chart was initially deployed. This is particularly important in relation to passwords, as upgrades must specify the same passwords configured in the initial deployment. For example, if the initial deployment was performed with the command

```bash
helm install --name my-app --set app.password=secret
```

the corresponding upgrade command would be

```bash
helm upgrade my-app --set app.password=secret
```

<blockquote class="note">
NOTE: Before upgrading, always check the chart documentation to see if there are any breaking changes between the latest version of the chart and its previous versions. Breaking changes are signified through changes in the chart’s major and minor version numbers; patch versions are typically safe to upgrade.
</blockquote>

Rollbacks are equally simple - just use the `helm rollback` command and specify the revision number to roll back to. For example, to roll back to the original version of the application (revision #1), use this command:

```bash
helm rollback my-todo-app 1
```

When you check the status with `helm history`, you will see that revision #2 will have been superseded by a copy of revision #1, this time labelled as revision #3.

<a href="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-17.png"><img src="/images/deploy-application-kubernetes-helm/deploy-application-kubernetes-helm-17.png" alt="NodePort service description"></a>

By now, you should have a good idea of how some of the key features available in Kubernetes, such as scaling and automatic load balancing, work. You should also have an appreciation for how Helm charts make it easier to perform common actions in a Kubernetes deployment, including installing, upgrading and rolling back applications.

To learn more about the topics discussed in this guide, use the links below:

<ul>
<li><a herf="https://docs.bitnami.com/kubernetes/how-to/deploy-application-kubernetes-helm/">origin</a></li>
<li><a href="https://docs.bitnami.com/kubernetes/how-to/secure-wordpress-kubernetes-managed-database-ssl-upgrades">Secure WordPress on Kubernetes with a Managed Cloud Database, TLS, Let’s Encrypt and Rolling Upgrades</a></li>
<li><a href="https://bitnami.com/kubernetes">Production-ready Kubernetes applications by Bitnami</a></li>
<li><a href="http://kubeapps.com/">Kubeapps</a></li>
<li><a href="https://kubernetes.io/">Kubernetes</a></li>
<li><a href="https://helm.sh/">Helm</a></li>
<li><a href="https://cloud.google.com/container-engine/">Google Container Engine</a></li>
<li><a href="https://github.com/kubernetes/minikube">Minikube</a></li>
<li><a href="https://bitnami.com">Bitnami</a></li>
</ul>
