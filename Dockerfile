FROM ubuntu:18.04

USER root
RUN apt-get update
RUN apt-get install -y --no-install-recommends openssh-server vim build-essential git golang ca-certificates iputils-ping curl
RUN useradd -m -s /bin/bash ethuser

WORKDIR /home/ethuser
USER ethuser
RUN mkdir data config
COPY --chown=ethuser config /home/ethuser/config
RUN git clone https://github.com/ethereum/go-ethereum
RUN cd go-ethereum && make all
USER root
RUN cp /home/ethuser/go-ethereum/build/bin/* /usr/local/bin
USER ethuser
RUN bootnode --genkey=bootnode.key
WORKDIR /home/ethuser

EXPOSE 8545 8546 30303 30303/udp
