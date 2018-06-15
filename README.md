# Kubelet v1.9.8

# Kubernetes

<img src="https://github.com/kubernetes/kubernetes/raw/master/logo/logo.png" width="100">

----

Kubernetes is an open source system for managing [containerized applications]
across multiple hosts; providing basic mechanisms for deployment, maintenance,
and scaling of applications.

Kubernetes builds upon a decade and a half of experience at Google running
production workloads at scale using a system called [Borg],
combined with best-of-breed ideas and practices from the community.

Kubernetes is hosted by the Cloud Native Computing Foundation ([CNCF]).
If you are a company that wants to help shape the evolution of
technologies that are container-packaged, dynamically-scheduled
and microservices-oriented, consider joining the CNCF.
For details about who's involved and how Kubernetes plays a role,
read the CNCF [announcement].

----

# Environment Variables Defaults


```
ETCD_SERVER="127.0.0.1"
ETCD_PREFIX="/cluster.local/network/"
APISERVER_IP="127.0.0.1"
KUBERNETES_CLUSTER_RANGE_IP="10.254.0.0/16"
KUBERNETES_CLUSTER_DNS="10.254.254.254"
CLUSTER_NAME="cluster.local"
PATH_BASE_KUBERNETES="/opt/kubernetes/"
DIR_CERTS="${PATH_BASE_KUBERNETES}/certificates"
KUBELET_CERTS="${DIR_CERTS}/kubelet"
KUBELET_PORT="10250"
KUBELET_PEM="kubelet.pem"
KUBELET_KEY_PEM="kubelet-key.pem"

```

# Docker command

```
docker run -d 
        --name <container_name> --privileged 
        -p 10250:10250  
        -e ETCD_SERVER="127.0.0.1"
        -e ETCD_PREFIX="/cluster.local/network/"
        -e APISERVER_IP="127.0.0.1"
        -e KUBERNETES_CLUSTER_RANGE_IP="10.254.0.0/16"
        -e KUBERNETES_CLUSTER_DNS="10.254.254.254"
        -e CLUSTER_NAME="cluster.local"
        -e PATH_BASE_KUBERNETES="/opt/kubernetes/"
        -e DIR_CERTS="${PATH_BASE_KUBERNETES}/certificates"
        -e KUBELET_CERTS="${DIR_CERTS}/kubelet"
        -e KUBELET_PORT="10250"
        -e KUBELET_PEM="kubelet.pem"
        -e KUBELET_KEY_PEM="kubelet-key.pem"
        -v <path_local_storage_with_certificates_api>:${DIR_CERTS} <image>:<tag>
```

# Docker example

```
docker run -d --name kubelet -h <name> --privileged=true --network host -p 10250:10250 -e ETCD_SERVER="<ip_server_etcd|name>" -e ETCD_PREFIX="/company.br/network" -e CLUSTER_NAME="cluster.local"  -v /opt/kubernetes/certs:/opt/kubernetes/certs kubelet
     
```