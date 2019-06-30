bootnode --nodekey /home/ethuser/bootnode.key 2>> /home/ethuser/bootnode.log &

echo "Setting bootnode to broadcast itself @ " $1
while [ 1 ]; do 
  echo  enode://$(bootnode -writeaddress --nodekey=/home/ethuser/bootnode.key)@$1:30303 | nc -q 1 -l -p 9090 || break
done
