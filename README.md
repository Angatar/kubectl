# Light kubectl container from busybox (d3fk/kubectl)
A super light container(~45Mb) with Kubectl from busybox prebuild on Docker hub with "automated build". This container is really useful to manage your kubernetes clusters from docker containers or from other pods, jobs, cronjobs ...

## Get this image (d3fk/kubectl)
The best way to get this d3fk/kubectl image is to pull the prebuilt image from the Docker Hub Registry.

pre-build from Docker hub with "automated build" option.

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

## Usage with Kubernetes cronjob
This container was created to be used into a cronjob in order to schedule forced rolling updates of our deployments so that our application gain in stablility by restarting pods with fresh containers.
... example files comming soon and explanation to be continued...
