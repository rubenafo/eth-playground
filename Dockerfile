FROM ubuntu:latest

USER root
RUN apt-get update
RUN apt-get install -y --no-install-recommends openssh-server vim build-essential git golang ca-certificates
RUN useradd -m -s /bin/bash ethuser

WORKDIR /home/ethuser
USER ethuser
RUN git clone https://github.com/ethereum/go-ethereum
RUN cd go-ethereum && make geth
USER root
RUN cp /home/ethuser/go-ethereum/build/bin/* /usr/local/bin
USER ethuser
#CMD ["./build/bin/geth"]
