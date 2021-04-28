FROM ubuntu:20.04

# Switch to ROOT mode
USER root

# Create a non-root user (for later usage by this Dockerfile)
RUN useradd -m -s /bin/bash ethuser

RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends --fix-missing openssh-server vim build-essential git ca-certificates iputils-ping curl netcat nodejs npm wget unzip

# Install v15.2 of golang
RUN wget -q https://golang.org/dl/go1.15.2.linux-amd64.tar.gz && tar -xzf go1.15.2.linux-amd64.tar.gz
RUN cp ./go/bin/* /usr/local/bin && cp -r go /usr/local
RUN rm go1.15.2.linux-amd64.tar.gz && rm -rf go

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
RUN export PATH=$PATH:/usr/local/go/bin

# Fetch the latest version (release) of go-ethereum
RUN curl -s "https://api.github.com/repos/ethereum/go-ethereum/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | xargs -I {} wget -q -O go-ethereum.tar.gz https://github.com/ethereum/go-ethereum/archive/refs/tags/{}.tar.gz
RUN mkdir go-ethereum
RUN tar xzf go-ethereum.tar.gz -C go-ethereum --strip-components 1

# Make go-ethereum
RUN cd go-ethereum && make geth && make all
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
