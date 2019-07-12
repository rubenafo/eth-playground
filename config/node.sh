LOG="/home/ethuser/node.log"

#
# Stop node
#
if [[ $1 = "stop" ]]; then
  echo "Stoping eth node in $HOSTNAME..."
  kill -9 `pgrep nodejs`
  kill -HUP `pgrep geth`
fi

#
# Start the node
#
if [[ $1 = "start" ]]; then
  echo "Starting eth node in $HOSTNAME..." >> $LOG
  bootnode=`curl ethbn:9090`
  echo "Bootnode: $bootnode" >> $LOG
  geth -datadir /home/ethuser/data -bootnodes $bootnode --nousb --networkid 500 --mine --rpc --rpccorsdomain "*" --rpcapi "eth,web3,personal,net" 2>> $LOG &
  sleep 2
  localAccount=`geth --exec "eth.coinbase" -verbosity 0 -datadir data/ attach`
  nodejs /home/ethuser/config/tools/broadcast.js 9091 $localAccount &
  echo "Starting monitor..." >> $LOG
  cd /home/ethuser/monitor
  ./node_modules/pm2/bin/pm2 start app.json &
fi

if [[ $1 = "init" ]]; then
  sed -i 's/##_##/'$HOSTNAME'/g' /home/ethuser/monitor/app.json
  echo "Init eth node in $HOSTNAME..." >> $LOG
  geth -datadir /home/ethuser/data init config/genesis.json 2>> $LOG
  echo "Creating account in $HOSTNAME..." >> $LOG
  geth -datadir /home/ethuser/data --password config/pwd account new >> $LOG
fi

