#!/bin/bash

kubelet \
--logtostderr=true \
--v=1 \
--address=0.0.0.0 \
--enable-debugging-handlers=true \
--port=${KUBELET_PORT} \
--allow-privileged=true \
--cluster-dns=${KUBERNETES_CLUSTER_DNS} \
--kubeconfig=${KUBELET_CERTS}/kubeconfig \
--cluster-domain=${CLUSTER_NAME} \
--fail-swap-on=false 
