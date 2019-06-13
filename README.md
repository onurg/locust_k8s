Distributed load testing using kubernetes and locust
======================

The repository contains everything needed to run a distributed load testing environment in kubernetes using a locust master and locust slaves. 

## Inputs explained

- Example of the DOCKER IMAGE is locally built
  - Docker Image is built off of Alpine-3.9 for minimal Python installation with Python 3.7
  - `docker-entrypoint.sh` is what sets the MODE and TARGETS
  - In the K8s image values found in `./locust-chart/values.yaml` are set to a LOCALLY BUILT DOCKER IMAGE
  - ImagePullPolicy needs to be set to 'NEVER' in order to use the locally built docker image

- Locust Master is what commands the Slaves to attack
  - Values set are:
    - LOCUST_MODE = MASTER
    - ATTACKED_HOST
- Locust Slaves are what attacks the targetted host
  - Values set are:
    - LOCUST_MODE = SLAVE
    - LOCUST_MASTER = (Where locust master is or the name of the component)
    - ATTACKED_HOST

- Given example has 1 master and 2 slave replicas which can be seen in `./locust-chart/values.yaml`
- `locustfile.py` is what integrates into `/locust` working directory in the docker container.  The file has the API calls which are used to test the target host.
- `attackedHost` is what sets the value for the target host for Slaves to Swarm (load test)


### Running
*Example is done in Minikube and Docker Based K8S Env*

Start minikube
```sh
minikube start
```

Set docker environment to minikube
```sh
eval $(minikube docker-env)
```

Initialize helm
```sh
helm init
```

Build docker image
```sh
docker build docker-image -t locust:0.0.1
```

Install helm charts onto kubernetes cluster
```sh
helm install locust-chart --name locust
```

Verify they run OK
```sh
kubectl get pods -w
```

List services to find locust URL
```sh
minikube service list
```

#### Cleanup
```sh
helm del --purge locust
```
---