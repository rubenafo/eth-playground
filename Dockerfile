FROM ubuntu:18.10

USER root
RUN apt-get update
RUN apt-get install -y --no-install-recommends --fix-missing openssh-server vim build-essential git golang ca-certificates iputils-ping curl netcat nodejs npm
RUN npm install web3 truffle express
RUN useradd -m -s /bin/bash ethuser

WORKDIR /home/ethuser
USER ethuser
RUN mkdir data config
RUN git clone https://github.com/ethereum/go-ethereum
RUN cd go-ethereum && make all
COPY --chown=ethuser config /home/ethuser/config
RUN cd /home/ethuser/config/truffle && npm install truffle
USER root
RUN cp /home/ethuser/go-ethereum/build/bin/* /usr/local/bin
USER ethuser

WORKDIR /home/ethuser
RUN git clone https://github.com/cubedro/eth-net-intelligence-api monitor
COPY ./netstat/app.json monitor
WORKDIR /home/ethuser/monitor
RUN npm install pm2
RUN npm install

WORKDIR /home/ethuser

EXPOSE 9090 9091 8545 8546 30301/udp 30303 30303/udp 30304
