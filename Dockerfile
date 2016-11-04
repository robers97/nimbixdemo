FROM ppc64le/ubuntu:16.04
MAINTAINER Nimbix, Inc.

ENV DEBIAN_FRONTEND noninteractive
ADD https://github.com/nimbix/image-common/archive/master.zip /tmp/nimbix.zip
WORKDIR /tmp
RUN apt-get update && apt-get -y install zip unzip openssh-server ssh infiniband-diags perftest libibverbs-dev libmlx4-dev libmlx5-dev sudo iptables curl wget vim python && apt-get clean
RUN unzip nimbix.zip && rm -f nimbix.zip
RUN /tmp/image-common-master/setup-nimbix.sh

ADD http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/ppc64el/cuda-repo-ubuntu1604_8.0.44-1_ppc64el.deb /tmp/cuda-repo-ubuntu1604_8.0.44-1_ppc64el.deb
RUN dpkg --install /tmp/cuda-repo-ubuntu1604_8.0.44-1_ppc64el.deb && apt-get update && apt-get -y install cuda-toolkit-8-0 && apt-get clean

RUN apt-get -y install openmpi-bin openmpi-doc libopenmpi-dev
RUN mkdir -m 0755 /tmp/gemm
RUN wget -O /tmp/gemm/gemm.tar.gz "https://drive.google.com/uc?export=download&id=0B4Q1OOAW91u6RzV4dXVBSlE1NDQ"

RUN find / -name 'nvidia-ml*'
RUN cd /tmp/gemm && tar zxvf gemm.tar.gz && make
RUN cd /tmp/gemm && mpirun -np 4 --allow-run-as-root ./gemm_copy -m500 -n500 -k500 -i10 -l10


# Nimbix JARVICE emulation
EXPOSE 22
RUN mkdir -p /usr/lib/JARVICE && cp -a /tmp/image-common-master/tools /usr/lib/JARVICE
RUN ln -s /usr/lib/JARVICE/tools/noVNC/images/favicon.png /usr/lib/JARVICE/tools/noVNC/favicon.png && ln -s /usr/lib/JARVICE/tools/noVNC/images/favicon.png /usr/lib/JARVICE/tools/noVNC/favicon.ico
WORKDIR /usr/lib/JARVICE/tools/noVNC/utils
RUN ln -s websockify /usr/lib/JARVICE/tools/noVNC/utils/websockify.py && ln -s websockify /usr/lib/JARVICE/tools/noVNC/utils/wsproxy.py
WORKDIR /tmp
RUN cp -a /tmp/image-common-master/etc /etc/JARVICE && chmod 755 /etc/JARVICE && rm -rf /tmp/image-common-master
RUN mkdir -m 0755 /data && chown nimbix:nimbix /data


