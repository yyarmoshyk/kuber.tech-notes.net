---
layout: default
title:  "Creating persistent storage"
date:   2020-01-27 10:42:00 +0000
categories: examples
parent: Examples
nav_order: 3
---

You can create a persistent volume claim (pvc) to provision NFS file storage for your cluster. Then, mount this pvc to a Deployment to ensure that data is available, even if the pods crash or shut down.

To view storage classes:
```bash
kubectl get storageclasses
```

Create a YAML file to define the persistent volume claim (pvc) information:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sample_pvc_name
  annotations:
    volume.beta.kubernetes.io/storage-class: "sample-file-storage"
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 20Gi
```

To mount the `pvc` to a deployment, reference the `pvc` in the deployment configuration like so:
```yaml
volumes:
    - name: sample_volume_name
      persistentVolumeClaim:
        claimName: sample_pvc_name
```

A​fter creating the YAML file, run:
```bash
kubectl apply –f filename
```

Verify that the volume was successfully mounted:
```bash
kubectl describe deployment deployment_name
```

F​or more information about configuring Kubernetes Volumes, see the [Kubernetes documentation](https://kubernetes.io/docs).
