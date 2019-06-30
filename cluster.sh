#!/bin/bash

#
# Bring the services up
#
function startNetwork {
  docker start ethbn eth1 eth2 eth3
  sleep 5
  echo "Starting network..."
  bootnodeIp=`docker inspect ethbn -f "{{.NetworkSettings.Networks.ethnet.IPAddress}}"`
  echo "Starting bootnde..."
  docker exec -u ethuser -d ethbn bash config/bootnode.sh $bootnodeIp
  sleep 5
  echo "Starting eth1, eth2, eth3..."
  docker exec -u ethuser -d eth1 bash config/node.sh start
  docker exec -u ethuser -d eth2 bash config/node.sh start
  docker exec -u ethuser -d eth3 bash config/node.sh start
  #show_info
}

#function show_info {
  #masterIp=`docker inspect -f "{{ .NetworkSettings.Networks.ethnet.IPAddress }}" ethbootnode`
  #echo "Hadoop info @ nodemaster: http://$masterIp:8088/cluster"
  #echo "Spark info @ nodemater  : http://$masterIp:8080/"
  #echo "DFS Health @ nodemaster : http://$masterIp:9870/dfshealth.html"
#}

if [[ $1 = "start" ]]; then
  startNetwork
  exit
fi

if [[ $1 = "stop" ]]; then
  docker exec -u ethuser -d ethbn bash node.sh stop
  docker exec -u ethuser -d eth1  bash node.sh stop
  docker exec -u ethuser -d eth2  bash config/node.sh stop
  docker exec -u ethuser -d eth3  bash config/node.sh stop
  docker stop ethbn eth1 eth2 eth3
  exit
fi

if [[ $1 = "deploy" ]]; then
  docker rm -f `docker ps -aq` # delete old containers
  docker network rm ethnet
  docker network create --driver bridge ethnet # create custom network

  # 3 nodes
  echo ">> Starting nodes ..."
  docker run -dP --network ethnet --name ethbn -h ethbn -it ethimg
  docker run -dP --network ethnet --name eth1 -it -h eth1 ethimg
  docker run -dP --network ethnet --name eth2 -it -h eth2 ethimg
  docker run -dP --network ethnet --name eth3 -it -h eth3 ethimg

  # Prepare bootnode
  echo ">> Preparing bootnode ..."
  docker exec -u ethuser -d ethbn bash config/genKey.sh
  #startNetwork
  exit
fi

if [[ $1 = "info" ]]; then
  show_info
  exit
fi

echo "Usage: cluster.sh deploy|start|stop"
echo "                 deploy - create a new Ethereum network"
echo "                 start  - start the existing containers"
echo "                 stop   - stop the running containers" 
echo "                 info   - useful URLs" 
