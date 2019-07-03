
#
# Stop node
#
if [[ $1 = "stop" ]]; then
  echo "Stoping eth node in $HOSTNAME..."
  kill -HUP `pgrep geth`
fi

#
# Start the node
#
if [[ $1 = "start" ]]; then
  echo "Starting eth node in $HOSTNAME..."
  bootnode=`curl ethbn:9090`
  echo "Bootnode: $bootnode"
  geth -datadir /home/ethuser/data -bootnodes $bootnode --networkid 500 2>> /home/ethuser/node.log
fi

if [[ $1 = "init" ]]; then
  echo "Init eth node in $HOSTNAME..."
  geth -datadir /home/ethuser/data init config/genesis.json 2>> /home/ethuser/node.log
fi
