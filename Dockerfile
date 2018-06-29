FROM centos:7.4.1708
LABEL MAINTAINER="unisp <cicero.gadelha@funceme.br | jonas.cavalcantineto@funceme.com>"

RUN yum update -y 
RUN yum install -y \
            vim \
            wget \
            epel-release.noarch
            


RUN yum install -y \
			openssl \
			yum-utils \
  			device-mapper-persistent-data \
  			lvm2 \
			supervisor \
			iptables \
			policycoreutils-python \
			libtool-ltdl \
			libseccomp \
			selinux-policy.noarch \
			selinux-policy-targeted.noarch

ADD packages/docker-engine-1.13.1-1.el7.centos.x86_64.rpm /tmp/docker-engine-1.13.1-1.el7.centos.x86_64.rpm 
ADD packages/docker-engine-selinux-1.13.1-1.el7.centos.noarch.rpm /tmp/docker-engine-selinux-1.13.1-1.el7.centos.noarch.rpm

RUN set -ex \
		&& rpm -ivh /tmp/docker-engine-selinux-1.13.1-1.el7.centos.noarch.rpm \
		&& rm -rf /tmp/docker-engine-selinux-1.13.1-1.el7.centos.noarch.rpm 
		
RUN set -ex \
		&& rpm -ivh /tmp/docker-engine-1.13.1-1.el7.centos.x86_64.rpm \
		&& rm -rf /tmp/docker-engine-1.13.1-1.el7.centos.x86_64.rpm 

#ENVIRONMENTS
ENV ETCD_SERVER="127.0.0.1"
ENV ETCD_PREFIX="/cluster.local/network/"
ENV APISERVER_IP="127.0.0.1"
ENV KUBERNETES_CLUSTER_RANGE_IP="10.254.0.0/16"
ENV KUBERNETES_CLUSTER_DNS="10.254.254.254"
ENV CLUSTER_NAME="cluster.local"
ENV PATH_BASE_KUBERNETES="/opt/kubernetes"
ENV DIR_CERTS="${PATH_BASE_KUBERNETES}/certs"
ENV DIR_CERTS_API="${PATH_BASE_KUBERNETES}/certs/api"
ENV KUBELET_CERTS="${DIR_CERTS}/modules/kubelet"
ENV KUBELET_PORT="10250"
ENV KUBELET_PEM="kubelet.pem"
ENV KUBELET_KEY_PEM="kubelet-key.pem"

#FLANNELD
ENV FLANNELD_VERSION "v0.9.1"
RUN	set -ex \
		&& wget https://github.com/coreos/flannel/releases/download/${FLANNELD_VERSION}/flanneld-amd64 -O /usr/bin/flanneld \
		&& chmod 755 /usr/bin/flanneld \
		&& mkdir -p /etc/cni/net.d


#CNI Install
ADD conf/10-flannel.conf	/etc/cni/net.d/10-flannel.conf

#KUBERNETES
ENV KUBERNETES_VERSION "v1.9.8"

RUN set -ex \
	&& wget https://github.com/kubernetes/kubernetes/releases/download/${KUBERNETES_VERSION}/kubernetes.tar.gz \
 	&& tar -zxvf kubernetes.tar.gz -C /tmp \
 	&& echo y | /tmp/kubernetes/cluster/get-kube-binaries.sh \
 	&& tar -zxvf /tmp/kubernetes/server/kubernetes-server-*.tar.gz -C /tmp/kubernetes/server \
 	&& mkdir -p ${PATH_BASE_KUBERNETES}/bin \
    && cp -a /tmp/kubernetes/server/kubernetes/server/bin/kubelet ${PATH_BASE_KUBERNETES}/bin/ \
    && ln -s ${PATH_BASE_KUBERNETES}/bin/kubelet /usr/local/sbin/kubelet \
	&& useradd kube \
	&& chown -R kube:kube ${PATH_BASE_KUBERNETES}/ \
 	&& rm -rf /tmp/kubernetes \
	&& rm -f kubernetes.tar.gz


#Digital Certificates
ADD conf/dkhub.funceme.CA.crt /etc/pki/ca-trust/source/anchors/dkhub.funceme.CA.crt
RUN	update-ca-trust

#PORTS
# TCP     10250       kubelet
EXPOSE 10250

COPY conf/supervisord.conf /etc/

ADD bin/start_flanneld.sh /start_flanneld.sh
ADD bin/start_docker.sh /start_docker.sh
ADD bin/start_kubelet.sh /start_kubelet.sh
ADD bin/start.sh /start.sh

RUN chmod +x /start_flanneld.sh
RUN chmod +x /start_docker.sh
RUN chmod +x /start_kubelet.sh
RUN chmod +x /start.sh

CMD ["./start.sh"]
