[![Docker Pulls](https://badgen.net/docker/pulls/d3fk/kubectl?icon=docker&label=pulls&cache=600)](https://hub.docker.com/r/d3fk/kubectl/tags) [![Docker Image Size](https://badgen.net/docker/size/d3fk/kubectl/latest?icon=docker&label=image%20size&cache=600)](https://hub.docker.com/r/d3fk/kubectl/tags) [![Docker build](https://img.shields.io/badge/automated-automated?style=flat&logo=docker&logoColor=blue&label=build&color=green&cacheSeconds=600)](https://hub.docker.com/r/d3fk/kubectl/tags) [![Docker Stars](https://badgen.net/docker/stars/d3fk/kubectl?icon=docker&label=stars&color=green&cache=600)](https://hub.docker.com/r/d3fk/kubectl) [![Github Stars](https://img.shields.io/github/stars/Angatar/kubectl?label=stars&logo=github&color=green&style=flat&cacheSeconds=600)](https://github.com/Angatar/kubectl) [![Github forks](https://img.shields.io/github/forks/Angatar/kubectl?logo=github&style=flat&cacheSeconds=600)](https://github.com/Angatar/kubectl/fork) [![Github open issues](https://img.shields.io/github/issues-raw/Angatar/kubectl?logo=github&color=yellow&cacheSeconds=600)](https://github.com/Angatar/kubectl/issues) [![Github closed issues](https://img.shields.io/github/issues-closed-raw/Angatar/kubectl?logo=github&color=green&cacheSeconds=600)](https://github.com/Angatar/kubectl/issues?q=is%3Aissue+is%3Aclosed) [![GitHub license](https://img.shields.io/github/license/Angatar/kubectl)](https://github.com/Angatar/kubectl/blob/master/LICENSE)

# Light kubectl container from scratch (Angatar> d3fk/kubectl)
A super lightweight container with Kubectl official binary only and ... that's it (~44MB -> [![Docker Image Size](https://badgen.net/docker/size/d3fk/kubectl/latest?icon=docker&label=compressed&cache=600)](https://hub.docker.com/r/d3fk/kubectl/tags)). It is made from scratch (downloaded from googleapis through alpine image and directly poured from alpine into scratch), prebuilt on Docker hub with "automated build" as multi-arch image from v1.25, updated everyday for its last version. This container is really useful to manage your kubernetes clusters from anywhere like simple docker containers or from other k8s pods, jobs, cronjobs ...

It can be used for CI/CD or simply as your main Kubectl command (version can be set by changing the tag).

This container is also especially convenient with tiny linux distro.

## Get this image (d3fk/kubectl)
The best way to get this d3fk/kubectl image is to pull the prebuilt image from the Docker Hub Registry.

The image is prebuilt as a multi-arch image from Docker hub with "automated build" option on [its code repository](https://github.com/Angatar/kubectl).

image name **d3fk/kubectl**
```sh
$ docker pull d3fk/kubectl:latest
```
Docker hub repository: https://hub.docker.com/r/d3fk/kubectl/

[![DockerHub Badge](https://dockeri.co/image/d3fk/kubectl?cache=600)](https://hub.docker.com/r/d3fk/kubectl)


## Kubectl version of d3fk/kubectl is the last stable version

The **d3fk/kubectl:latest** multi-arch image available from the Docker Hub is made with automated build auto-triggered every day so that using the d3fk/kubectl image ensures you to have the last **stable** version available of Kubectl within 24H max after its release. This last stable version of Kubectl is currently related to the last release of Kubernetes which is [reported Here](https://storage.googleapis.com/kubernetes-release/release/stable.txt).

As it is a multi-arch image it will fit most of architectures:

- linux/amd64
- linux/386
- linux/arm/v6
- linux/arm/v7
- linux/arm64/v8
- linux/ppc64le
- linux/s390x

Therefore, you could even use this d3fk/kubectl container to manage K8s clusters from a Raspberry Pi.

## Previous Kubectl versions
In case you require a previous version or simply a fixed version of Kubectl, the following tagged images are also made available from the Docker hub (as multi-arch image from d3fk/kubectl:v1.25). In each of these images the version is fixed and won't be changed so that it was freezed in a release of the code repo and built from the Docker hub by automated build (the code is available from the "releases" section of this image code repository on GitHub). These images are stable and won't be rebuilt in the future:
* for version 1.30.4: **d3fk/kubectl:v1.30**
* for version 1.29.5: **d3fk/kubectl:v1.29**
* for version 1.28.10: **d3fk/kubectl:v1.28**
* for version 1.27.5: **d3fk/kubectl:v1.27**
* for version 1.26.8: **d3fk/kubectl:v1.26**
* for version 1.25.5: **d3fk/kubectl:v1.25**
* for version 1.24.8: **d3fk/kubectl:v1.24**
* for version 1.23.6: **d3fk/kubectl:v1.23**
* for version 1.22.6: **d3fk/kubectl:v1.22**
* for version 1.21.4: **d3fk/kubectl:v1.21**
* for version 1.20.8: **d3fk/kubectl:v1.20**
* for version 1.19.5: **d3fk/kubectl:v1.19**
* for version 1.18.2: **d3fk/kubectl:v1.18**
* for version 1.17.5: **d3fk/kubectl:v1.17**
* for version 1.16.9: **d3fk/kubectl:v1.16**

## Basic usage
```sh
$ docker run --rm d3fk/kubectl
```
This command will display the list of kubectl commands available

## Configuration
If you want to connect to a remote cluster it is required to load your own configuration.
```sh
$ docker run --rm --name kubectl -v /path/to/your/kube/config:/.kube/config d3fk/kubectl
```

e.g: if you want to list the pods in your cluster
```sh
$ docker run --rm --name kubectl -v $HOME/.kube/config:/.kube/config d3fk/kubectl get pods
```


In case you need to use yaml files, create configmaps or use any other files with kubectl, a WORKDIR has been set in the d3fk/kubectl container at the "/files" path so that you simply have to use a volume to mount your files on this path and use them from the d3fk/kubectl container.

e.g: to create a deployment from a deployment.yaml file in your current directory
```sh
$ docker run --rm --name kubectl \
             -v $(pwd):/files \
             -v $HOME/.kube/config:/.kube/config \
             d3fk/kubectl create -f deployment.yaml
```


If you need to use kubectl with terminal interaction with a k8s component you'll have to add the -ti option to the docker running command.

e.g: for entering into a container shell within a pod for debugging/inspecting ... purpose

```sh
$ docker run -ti --rm --name kubectl \
             -v $(pwd):/files \
             -v $HOME/.kube/config:/.kube/config \
             d3fk/kubectl exec -ti deployment/examplebashpod -- bash
```



Tips:
It might be useful to create a command alias for your shell so that you can use this docker container as if kubectl binary was in your system $PATH.
```sh
alias k='docker run --rm -ti -v $(pwd):/files -v $HOME/.kube/config:/.kube/config d3fk/kubectl'
```
You can then run your d3fk/kubectl commands as simple as the following:
```sh
$ k get pods
```

## Usage within Kubernetes
This container was initially created to be used from a K8s CronJob in order to schedule forced rolling updates of specific deployments so that our related scaled applications can gain in stability by restarting pods regularly with fresh containers with no downtime.

In order to illustrate the following descriptions and for testing purposes, template YAML files have been placed in the [k8s directory of this code repository](https://github.com/Angatar/kubectl/blob/master/k8s/).

Rolling updates of your pods can simply be triggered by patching your targeted deployment or by rolling restart with the kubectl roullout restart ... it is important to define a rolling-update strategy to be sure that it will trigger the wished rolling-update behaviour while patching your deployment, ex:
```yaml
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1 # how many pods we can add at a time
      maxUnavailable: 1 # how many pods can be unavailable during the rolling update
```
A complete template deployment file is available from the k8s directory: [test-deployment.yaml](https://github.com/Angatar/kubectl/blob/master/k8s/test-deployment.yaml)

The default k8s RBAC rules do not allow to run a patch or rollout from another pod. So, to make it works we have to create a RBAC Role and RoleBinding with the needed rights e.g.: for patching we need to "get" and "patch".

For testing purposes and as we are creating a dedicated RBAC Role and RoleBinding we will work on a dedicated namespace "r-updated" so that these modifications won't touch your current default namespace and will only apply to the targeted deployments for regular rolling-updates (the CronJob and the targeted deployments as well as the dedicated RBAC rules have to be in the same namespace). If you want to apply these changes to an existing namespace you'll have to edit the namespace line in the provided templates for the deployment, rbac, configmap and cronjob. Otherwise you simply have to create the "r-updated" namespace:

```sh
$ kubectl create namespace r-updated
```
The template RBAC yaml file containing the required Role and RoleBinding to create a rolling update is available from the k8s directory of the repo as well ([rbac-rupdate.yaml](https://github.com/Angatar/kubectl/blob/master/k8s/rbac-rupdate.yaml))... please adapt the rights, and namespaces to your needs.

```sh
$ kubectl create -f rbac-rupdate.yaml
```
A configmap to be used with your pod/job/cronjob that will make use of the d3fk/kubectl container ... can easily be created from the .kube/config file with the following kubectl command (assuming your config file of interest is located into $HOME/.kube ):

```sh
$ kubectl create configmap kubeconfig --namespace r-updated --from-file $HOME/.kube
```

You can use the provided YAML file ([rolling-update-cronjob.yaml](https://github.com/Angatar/kubectl/blob/master/k8s/rolling-update-cronjob.yaml)) available from the k8s directory in this repo as a template for your CronJob (for test purposes this cronjob will trigger a job every minute, you'll have to adapt the cron settings to your needs).

This template CronJob yaml file is using the configmap "kubeconfig" created previously to load the kubectl configuration file (change this to your requirements). Once configured with the targeted deployment (simply edit the deployment name in the CronJob file), the k8s CronJob can be created from the file:
```sh
$ kubectl create -f rolling-update-cronjob.yaml
```
Then, k8s rolling updates will be made regularly based on your CronJob configuration.

[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/Angatar/kubectl/blob/master/LICENSE)
