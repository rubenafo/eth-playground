
# Stop node
if [[ $1 = "stop" ]]; then
  echo "Stoping eth node in $HOSTNAME..."
  kill -HUP `pgrep geth`
fi

if [[ $1 = "start" ]]; then
  echo "Starting eth node in $HOSTNAME..."
  bootnode=`curl ethbn:9090`
  echo "Bootnode: $bootnode"
  geth -datadir /home/ethuser/data -bootnodes $bootnode 2>> /home/ethuser/node.log
fi
