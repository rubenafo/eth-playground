bootnode --nodekey /home/ethuser/bootnode.key 2>> /home/ethuser/node.log &
sleep 2
nodejs /home/ethuser/config/tools/broadcast 9090 enode://$(bootnode -writeaddress --nodekey=/home/ethuser/bootnode.key)@$1:0?discport=30301 &
