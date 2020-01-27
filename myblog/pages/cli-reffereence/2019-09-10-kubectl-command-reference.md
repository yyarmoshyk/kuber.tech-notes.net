---
layout: default
title:  "Kubectl command reference"
date:   2019-09-10 16:06:00 +0000
categories: cli
parent: CLI refference
---

<div><h2>Basic syntax</h2>
<p><strong>	&lt;verb&gt; &lt;objecttype&gt; [&lt;subtype&gt;] &lt;instancename&gt; [flags]</strong></p>
<p>Where the <strong>&lt;verb&gt; </strong>is an action such as: <strong>create</strong>, <strong>run</strong>, <strong>expose</strong>, <strong>autoscale</strong>, and so on. </p>
<p><strong>&lt;objecttype&gt;</strong> is the object type, such as a <strong>service</strong>. Some objects have subtypes that you can specify with the <strong>create</strong> command. For example, a service has subtypes of <strong>ClusterIP</strong>, <strong>LoadBalancer</strong>, <strong>NodePort</strong>, and so on. Use the <strong>-h</strong> flag to find the arguments and flags that are supported by a specific subtype. Types and subtypes are case-sensitive.</p>
<p><strong>&lt;instancename&gt;</strong> specifies the name of the object. Names are also case-sensitive. If you omit the name, details for all resources of the specified type are displayed.</p>
<p>Optionally, you can specify flags that do various functions. For example, you can use the <strong>-s</strong> flag to specify the address and port of the Kubernetes API server. Flags that you specify from the command line override default values and any corresponding environment variables.</p>
<p>To answer quiz questions about <strong>kubectl</strong> commands in this course, you only need to enter the <strong>verb</strong>, <strong>object type</strong>, and <strong>subtype</strong>, if applicable. You do not need to specify an instance name or any optional flags with the command. </p>
<p>For a complete list of kubectl commands, see the <a href="https://kubernetes.io/docs/user-guide/kubectl/" target="_blank">Kubernetes documentation</a>.</p>
<h2>Some useful commands</h2><p>Get help with <strong>kubectl</strong> commands:</p>
<p><strong>$ kubectl help</strong></p>
<p>Get the state of your cluster:</p>
<p><strong>$ kubectl cluster-info</strong></p>
<p>Get all the Nodes of your cluster:</p>
<p><strong>$ kubectl get nodes -o wide</strong></p>
<p>Get information about the Pods of your cluster:</p>
<p><strong>$ kubectl get pods -o wide</strong></p>
<p>Get information about the Replication Controllers of your cluster:</p>
<p><strong>$ kubectl get rc -o wide</strong></p>
<p>Get information about the Services of your cluster:</p>
<p><strong>$ kubectl get services</strong></p>
<p>Get full configuration information about a Service:</p>
<p><strong>$ kubectl get service &lt;instancename&gt;  -o json</strong></p>
<p>Get the IP address of a Pod:</p>
<p><strong>$ kubectl get pod &lt;instancename&gt;  -template=&#123;&#123;.status.podIP&#125;&#125;</strong></p>
<p>Delete a Pod:</p>
<p><strong>$ kubectl delete pod NAME</strong></p>
<p>Delete a Service:</p>
<p><strong>$ kubectl delete service &lt;instancename&gt; </strong></p>
<h1>Useful links</h1><p><strong>kubectl</strong> reference - <a href="https://kubernetes.io/docs/reference/" target="_blank" rel="noopener nofollow">https://kubernetes.io/docs/reference/</a></p>
<p><strong>kubectl</strong> cheat sheet - <a href="https://kubernetes.io/docs/user-guide/kubectl-cheatsheet/" target="_blank" rel="noopener nofollow">https://kubernetes.io/docs/user-guide/kubectl-cheatsheet/</a> </p>
</div>
