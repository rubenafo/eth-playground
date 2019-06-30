bootnode --genkey=bootnode.key

while [ 1 ]; do 
  echo -e \"HTTP/1.1 200 OK\n\nenode://$(bootnode -writeaddress --nodekey=/home/ethuser/node.key)@$(POD_IP):30301\" | nc -l -v -p 8080 || break
done
