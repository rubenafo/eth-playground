# Prepares the env starting minikube and setting the internal docker daemon
minikube start
eval $(minikube docker-env)

#minikube dashboard
