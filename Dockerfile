FROM ubuntu:20.04

# Switch to ROOT mode
USER root

# Create a non-root user (for later usage by this Dockerfile)
RUN useradd -m -s /bin/bash ethuser

RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends --fix-missing openssh-server vim build-essential git ca-certificates iputils-ping curl netcat nodejs npm wget
RUN wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> /root/.bashrc
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/ethuser/.bashrc

# Define the WORKDIR, because recent versions of NodeJS and NPM require it
# Otherwise packages are installed at the container root folder
WORKDIR /home/ethuser

# Switch to the LTS version of NodeJS
RUN npm install -g n && n lts

# Install required packages
RUN npm install web3 express

# Switch to the non-root user for subsequent commands
USER ethuser

RUN mkdir data config
RUN git clone https://github.com/ethereum/go-ethereum
RUN cd go-ethereum && make geth
RUN cd go-ethereum && make all
COPY --chown=ethuser config /home/ethuser/config
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
