LOG="/home/ethuser/node.log"

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
  echo "Starting eth node in $HOSTNAME..." >> $LOG
  bootnode=`curl ethbn:9090`
  echo "Bootnode: $bootnode" >> $LOG
  geth -datadir /home/ethuser/data -bootnodes $bootnode --nousb --networkid 500 --mine --rpc 2>> $LOG
  localAccount=`geth --exec \"eth.coinbase\" -verbosity 0 -datadir data/ attach`
  echo "Broadcasting local account @ " $1 >> $LOG
  while [ 1 ]; do 
     echo  $localAccount | nc -q 1 -l -p 9091 || break
  done
fi

if [[ $1 = "init" ]]; then
  echo "Init eth node in $HOSTNAME..." >> $LOG
  geth -datadir /home/ethuser/data init config/genesis.json 2>> $LOG
  echo "Creating account in $HOSTNAME..." >> $LOG
  geth -datadir /home/ethuser/data --password config/pwd account new >> $LOG
fi

