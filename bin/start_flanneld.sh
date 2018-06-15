#!/bin/bash

/usr/bin/flanneld \
    -v 2 \
    -etcd-endpoints=http://${ETCD_SERVER}:2379 \
    -etcd-prefix=${ETCD_PREFIX}
