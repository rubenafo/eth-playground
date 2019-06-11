FROM ubuntu:latest

USER root
RUN apt-get update
RUN apt-get install -y --no-install-recommends openssh-server vim build-essential git golang ca-certificates
RUN useradd -m -s /bin/bash ethuser

WORKDIR /home/ethuser
USER ethuser
RUN git clone https://github.com/ethereum/go-ethereum
WORKDIR go-ethereum
RUN make geth

