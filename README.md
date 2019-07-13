# eth-playground
An Ethereum private network running on Docker to mess with Blockchain and smart contracts.

## Motivation

To provide a simple, private Ethereum setup as close as possible to a real scenario where the nodes are completely independent and just share the same network.   
The setup is simple enough to allow further experiments (it's a playground after all) and deals with all the Docker complexity and network details as node discovery.

## Features 

Builds and maintains 3 independent nodes in a Docker network and a *bootnode* to connect them.   
* Vanilla ethereum: everything is built and setup from scratch
* Each node gets its own IP address and eth account, also:
   * broadcasts its default account id from the **9090** TCP port.
   * reports stats to the *netsat* node that is running [eth-netstats](https://github.com/cubedro/eth-netstats)
* The *bootnode* node connects nodes dynamically when added into the network
* A *netstat* node displaying the [eth-netstat dashboard](https://github.com/cubedro/eth-netstats)
* A bunch of scripts to control the cluster: build, start, stop, login into nodes, etc

## Install

1. Clone this repo
2. cd eth-playground
2. ./build.sh
3. ./cluster deploy

Docker will display 4 nodes (ethbn, eth1, eth2, eth3) running inside the **ethnet** network.

## Usage

Once installed the nodes are fully independentent and self-discoverable thanks to the bootnode in place (**ethbn**).

* cluster login _nodeName_ : logs automatically inside the selected node
* cluster geth _nodeName_  : opens a geth console inside the selected node
* cluster stop : stops the eth network
* cluster start: starts the network again
* cluster deploy: stops and deploys the whole network again
* cluster info: displays the netstat node URL containing the dashboard
