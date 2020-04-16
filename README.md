# Light kubectl container from busybox (d3fk/kubectl)
A super light container with Kubectl(~45Mb) from busybox, prebuilt on Docker hub with "automated build". This container is really useful to manage your kubernetes clusters from docker containers or from other k8s pods, jobs, cronjobs ...

## Get this image (d3fk/kubectl)
The best way to get this d3fk/kubectl image is to pull the prebuilt image from the Docker Hub Registry.

The image is prebuilt from Docker hub with "automated build" option.

image name **d3fk/kubectl**
```sh
$ docker pull d3fk/kubectl:latest
```
Docker hub repository: https://hub.docker.com/r/d3fk/kubectl/

## Basic usage
```sh
$ docker run --rm d3fk/kubectl
```
This command will display the list of kubectl commands available

## Configuration
If you want to connect to a remote cluster it is required to load your own configuration.
```sh
$ docker run --rm --name kubectl -v /path/to/your/kube/config:/root/.kube/config d3fk/kubectl
```

e.g: if you want to list the pods in your cluster 
```sh
$ docker run --rm --name kubectl -v /path/to/your/kube/config:/root/.kube/config d3fk/kubectl get pods
```

Tips:
It might be useful to create an alias into your .bashrc so that you can use this docker container as if kubectl was in your system (standard use with [RancherOS](https://github.com/rancher/os/)).
```sh
alias k='docker run --rm --name kubectl -v /path/to/your/kube/config:/root/.kube/config d3fk/kubectl'
```
You can then run your d3fk/kubectl commands as simple as the following:
```sh
$ k get pods
```

## Usage with Kubernetes cronjob
This container was created to be used into a cronjob in order to schedule forced rolling updates of our deployments so that our application gain in stablility by restarting pods with fresh containers.
... example files comming soon and explanation to be continued...
