---
layout: default
title:  "Volumes"
date:   2020-01-27 10:42:00 +0000
categories: cli
parent: Kubernetes overview
nav_order: 5
---
On-disk files in a Container are ephemeral, which presents some problems for non-trivial applications when running in Containers. First, when a Container crashes, kubelet will restart it, but the files will be lost - the Container starts with a clean state. Second, when running Containers together in a Pod it is often necessary to share files between those Containers. The Kubernetes Volume abstraction solves both of these problems

<center><img src="/images/Kube-volumes.png"></center>

## P​ersistent storage
You can use different methods to persist data for a workload:
1. You can store data by using another cloud service that is hosted either in the private cloud or elsewhere in the enterprise. This becomes a stateless workload.
1. After a storage administrator creates a PersistentVolume (PV), a developer can make a PersistentVolumeClaim (PVC) against the PV.
1. You can persist configuration and settings by using ConfigMaps and Secrets.
1. A PVC makes a dynamic request for storage by using a defined StorageClass that supports a specific storage provider and set of use cases.

**Peristent volume** is a storage resource in the cluster. It's lifecycle is independent of any individual pod that uses it. This API object encapsulates the details of the storage implementation or cloud-provider-specific storage system.

**Peristetnt volume claim** is a storage request, or claim, that a developer makes. Claims request specific sizes of storage and other aspects, such as access modes.

The PVs can be provisioned statically or dynamically.
* **Static**: A cluster administrator creates several PVs. They carry the details of the real storage, which is available for use by cluster users. They exist in the Kubernetes API and are available for consumption.
* **Dynamic** When none of the static PVs that the administrator created matches a user’s PVC, the cluster might try to dynamically provision a volume for the PVC. This provisioning is based on `StorageClasses`. For dynamic provisioning to occur, the administrator must create and configure a storage class and the PVC must request that storage class.

**StorageClass** describes an offering of storage and allows for the dynamic provisioning of PVs and PVCs based on those controlled definitions. [More about storage classes](https://kubernetes.io/docs/concepts/storage/storage-classes/).

Each StorageClass contains the fields provisioner, parameters, and reclaimPolicy, which are used when a PersistentVolume belonging to the class needs to be dynamically provisioned

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
reclaimPolicy: Retain
allowVolumeExpansion: true
mountOptions:
  - debug
volumeBindingMode: Immediate
```

The `reclaimPolicy` for a PV tells the cluster what to do with the volume after it is released of its claim. Volumes can either be `retained` or `deleted`.

### Volume lifecycle
The Reclaim policy tells the cluster what to do with the Volume after it is released from its claim.
* `Retain` allows for the manual reclamation of the storage asset. The PVC is deleted, but the PV remains.
* `Delete` removes both objects from the cluster and the associated storage asset from the external infrastructure.

Access modes define how Volumes can be mounted in the manner that is supported by the storage provider.
* `ReadWriteOnce` (RWO) can be mounted as read/write by a single Node and Pod.
* `ReadOnlyMany` (ROX) can be mounted as read-only by many Nodes and Pods.
* `ReadWriteMany` (RWX) can be mounted as read/write by many Nodes and Pods.

## Links
1. [Kubernetes storage](https://kubernetes.io/docs/concepts/storage/)
1. [Creating persistent storage](/pages/Examples/2020-01-27-creating-persistant-volume.html)
