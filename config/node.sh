
# Stop node
if [[ $1 = "stop" ]]; then
  echo "Stoping eth node in $HOSTNAME..."
  killall -HUP geth
fi
