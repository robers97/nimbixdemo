FROM nimbix/ubuntu-cuda-ppc64le
MAINTAINER Nimbix, Inc.

RUN apt-get -y install openmpi-bin openmpi-doc libopenmpi-dev
RUN mkdir -m 0755 /opt/gemm
RUN wget -O /opt/gemm/gemm_copy "https://drive.google.com/uc?export=download&id=0B4Q1OOAW91u6X1V2TktvWlNtdkk"
#RUN cd /tmp/gemm && mpirun -np 4 --allow-run-as-root ./gemm_copy -m500 -n500 -k500 -i10 -l10
