---
layout: default
title:  "Prometheus + Grafana to monitor MySQL server"
date:   2020-08-17 15:40:00 +0000
categories: examples
parent: Examples
nav_order: 3
---
## Description
The primary purpose of this note is to describe the procedure of getting Grafana and Prometheus to run in Kubernetes.
It also includes the [MySQL helm deployment](https://github.com/helm/charts/tree/master/stable/mysql) as an example of service that is to be monitored by Prometheus and to build grafs with Graphana.
I'm going to use AWS EKS as a kubernetes cluster. The [terraform instructions to provision EKS cluster](https://github.com/yyarmoshyk/aws-kubernetes-setup-terraform) can be found in [my github.com account](https://github.com/yyarmoshyk/).
Make sure to [configure your PC to work wit the new EKS cluster](/pages/EKS/2019-11-25-Configure-kubectl-to-work-with-eks.html)

## Prometheus
There is no need to do extra effort to install prometheus. You can grab the existing [Prometheus helm chart](https://github.com/helm/charts/tree/master/stable/prometheus) and install it with a small customisation: we need to specify the service type to be `LoadBalancer` so that EKS creates ELB and expose prometheus server over it:
```bash
helm install prometheus-sample  stable/prometheus --set server.service.type=LoadBalancer
```
The output will contain the number of commands to find the desired access points but since we specified the `LoadBalancer` as service type run the following commands to get the public access point:
```bash
export PROMETHEUS_SERVICE_ADDR=$(kubectl get svc --namespace default prometheus-sample-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo http://$PROMETHEUS_SERVICE_ADDR:80
```
## Grafana
There is no need to do extra effort to install `Grafana`. You can grab the [existing Grafana helm chart](https://github.com/helm/charts/tree/master/stable/grafana) and install it with a small customisation: we need to specify the service type to be `LoadBalancer` so that EKS creates ELB and expose `Grafana` UI server over it:
```bash
helm install grafana-sample  stable/grafana --set service.type=LoadBalancer
```
Run the following to get the ALB address:
```bash
export GRAFANA_SERVICE_ADDR=$(kubectl get svc --namespace default grafana-sample -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo http://$GRAFANA_SERVICE_ADDR:80
```
Read the `Grafana` admin password by running the following:
```bash
kubectl get secret --namespace default grafana-sample -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
Login to the `Grafana` web interface using the `$SERVICE_ADDR` and the admin password.
Add prometheus datasource using the `$PROMETHEUS_SERVICE_ADDR`

Really great set of MySQL and Aurora dashboards is available in [percona project](https://github.com/percona/grafana-dashboards). At this time you can download and import all dashboards that have MySQL in the name.

## MySQL
There is a set of customisations that we need to apply and this is why I've prepared the [customised values.yaml](https://raw.githubusercontent.com/yyarmoshyk/mysql-kubernetes-with-prometheus-exporter/master/values.yaml)

The following default values were updated:
* mysqlRootPassword
* mysqlUser
* mysqlPassword
* mysqlDatabase
* configurationFiles.mysql.cnf
* metrics.enabled
* metrics.annotations
* metrics.flags

Most of these changes can be provided using `--set` argument, but I'm not really sure how to provide `metrics.annotations` and `configurationFiles.mysql.cnf`.
The `metrics.annotations` is required to run the `mysqld-exporter` container in the pod to export metrics into `Prometheus`.
Custom `mysql.cnf` is required to enable `slow_query_log`.
```bash
helm install mysql-sample -f https://raw.githubusercontent.com/yyarmoshyk/mysql-kubernetes-with-prometheus-exporter/master/values.yaml stable/mysql
```

The [customisation of `metrics.annotations`](https://github.com/yyarmoshyk/mysql-kubernetes-with-prometheus-exporter/blob/master/values.yaml#L161) makes `Prometheus` find `MySQL` resources (pod, service) in Kubernetes.

Once `MySQL` pod with 2 containers is running you can go back into Grafana UI and check the imported dashboards. They should contain the metrics that Prometheus is gathering from MySQL server container.
