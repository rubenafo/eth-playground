# Prepares the env starting minikube and setting the internal docker daemon
./stop.sh
minikube start
eval $(minikube docker-env)

#minikube dashboard
