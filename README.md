[![Docker Pulls](https://img.shields.io/docker/pulls/d3fk/kubectl?logo=docker)](https://hub.docker.com/r/d3fk/kubectl/tags) [![Docker Image Size](https://img.shields.io/docker/image-size/d3fk/kubectl/latest?arch=amd64&logo=docker)](https://hub.docker.com/r/d3fk/kubectl/tags) [![Docker Hub](https://img.shields.io/badge/Docker%20Hub-kubectl-2496ED?logo=docker)](https://hub.docker.com/r/d3fk/kubectl) [![Docker Stars](https://img.shields.io/docker/stars/d3fk/kubectl?logo=docker)](https://hub.docker.com/r/d3fk/kubectl) [![GitHub Stars](https://img.shields.io/github/stars/Angatar/kubectl?logo=github&style=flat)](https://github.com/Angatar/kubectl) [![GitHub forks](https://img.shields.io/github/forks/Angatar/kubectl?logo=github&style=flat)](https://github.com/Angatar/kubectl/fork) [![GitHub open issues](https://img.shields.io/github/issues-raw/Angatar/kubectl?logo=github)](https://github.com/Angatar/kubectl/issues) [![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/Angatar/kubectl?logo=github)](https://github.com/Angatar/kubectl/issues?q=is%3Aissue+is%3Aclosed) [![GitHub license](https://img.shields.io/github/license/Angatar/kubectl)](https://github.com/Angatar/kubectl/blob/master/LICENSE)

# Light kubectl container from scratch (Angatar> d3fk/kubectl)
A super lightweight container with only Kubectl official binary plus a default non-root user... that's it. It is made from scratch (downloaded from dl.k8s.io using an Alpine build stage and copied into scratch), prebuilt on Docker hub with "automated build" as multi-arch image from v1.25, updated everyday for its last version. This container is really useful to manage your kubernetes clusters from anywhere like simple docker containers or from other k8s pods, jobs, cronjobs ...

It can be used for CI/CD or simply as your main Kubectl command (version can be set by changing the tag).

This container is also especially convenient with tiny/immutable linux distro such as [Flatcar Container Linux](https://github.com/flatcar/Flatcar), taking advantage of the immutability of Docker images without requiring the use of a package manager... see-> [Tips: Super fast setup](#TipsAnchor)

## Get this image (d3fk/kubectl)
The best way to get this d3fk/kubectl image is to pull the prebuilt image from the Docker Hub Registry.

The image is prebuilt as a multi-arch image from Docker hub with "automated build" option on [its code repository](https://github.com/Angatar/kubectl).

image name **d3fk/kubectl**
```sh
$ docker pull d3fk/kubectl:latest
```
Docker hub repository: https://hub.docker.com/r/d3fk/kubectl/

## Kubectl version of d3fk/kubectl is the last stable version

Docker Hub builds **d3fk/kubectl:latest** daily from the version published in the upstream [stable release channel](https://dl.k8s.io/release/stable.txt).

The official binaries support these platforms:

- linux/amd64
- linux/386
- linux/arm/v7
- linux/arm64/v8
- linux/ppc64le
- linux/s390x

On Raspberry Pi, use an ARMv7 or ARM64 model. The official 32-bit ARM binary requires ARMv7.

## Pinned Kubectl versions

Each `v1.xx` tag contains a fixed upstream patch release from [GitHub Releases](https://github.com/Angatar/kubectl/releases). Choose a `kubectl` version within one minor version of your cluster's API server. See the [Kubernetes version skew policy](https://kubernetes.io/releases/version-skew-policy/#kubectl). Older series are available for compatibility with existing clusters. See [Kubernetes releases](https://kubernetes.io/releases/) for maintained versions.

Starting with `v1.31`, each pinned tag targets the six platforms listed above. The 32-bit ARM image uses `linux/arm/v7`. An ARMv6 device, such as the original Raspberry Pi Zero, requires a build that targets ARMv6.

* for version 1.37.2: **d3fk/kubectl:v1.37**
* for version 1.36.6: **d3fk/kubectl:v1.36**
* for version 1.35.10: **d3fk/kubectl:v1.35**
* for version 1.34.13: **d3fk/kubectl:v1.34**
* for version 1.33.13: **d3fk/kubectl:v1.33**
* for version 1.32.13: **d3fk/kubectl:v1.32**
* for version 1.31.14: **d3fk/kubectl:v1.31**
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

## Default User

Starting from version 1.31 the d3fk/kubectl container image includes a non-root default user named `kubectl` with a UID of `6009` to follow [Docker's best practices](https://docs.docker.com/scout/policy/#default-non-root-user). This UID was chosen to minimize interference with existing users on your local filesystem  (e.g, access to config files, mounted volumes...).

If you were using d3fk/kubectl versions below v1.31, this non-root user setup should not impact your usual practices with d3fk/kubectl, except exceptional cases where you are dealing with files or directories that have specific restricted read access. If you encounter such cases and wish to replicate the behavior of running kubectl locally, you can set the container user to your own UID by using the `--user` option.


## Configuration
To connect to a remote cluster, you need to load your own configuration.
```sh
$ docker run --rm --name kubectl -v /path/to/your/kube/config:/.kube/config d3fk/kubectl
```

For example, to list the pods in your cluster:
```sh
$ docker run --rm --name kubectl -v $HOME/.kube/config:/.kube/config d3fk/kubectl get pods
```


If you need to use YAML files, create configmaps, or work with other files using kubectl, a `WORKDIR` has been set in the `d3fk/kubectl` container at the `/files` path. You can mount your files to this path and use them within the container.

For example, to create a deployment from a `deployment.yaml` file in your current directory:
```sh
$ docker run --rm --name kubectl \
             -v $(pwd):/files \
             -v $HOME/.kube/config:/.kube/config \
             d3fk/kubectl create -f deployment.yaml
```


If you need to use kubectl with terminal interaction with a k8s component you'll have to add the -ti option to the docker running command.

For example, to enter a container shell within a pod for debugging or inspection purposes:

```sh
$ docker run -ti --rm --name kubectl \
             -v $(pwd):/files \
             -v $HOME/.kube/config:/.kube/config \
             d3fk/kubectl exec -ti deployment/examplebashpod -- bash
```


### Tips:
#### working with limited access rights
If you are working with files or directories that have restricted access rights, you can set your current user as the default container user using the `--user` option.
You can simply dynamically incorporate your user ID and group ID into the run command using `$(id -u)` and `$(id -g)`.

For example:

```sh
$ docker run -ti --rm --name kubectl \
             --user $(id -u):$(id -g) \
             -v $(pwd):/files \
             -v $HOME/.kube/config:/.kube/config \
             d3fk/kubectl apply -f deployment.yaml
```


<h4 id="TipsAnchor"></h4>


#### Super fast setup
It might be useful to create a command alias for your shell so that you can use this docker container as if kubectl binary was in your system $PATH.
For a simple rapid local setup you can copy paste the following line in your prompt (assuming $HOME/.kube/congfig file is accessible to the current user) :
```sh
alias k='docker run --rm -ti --user $(id -u):$(id -g) -v $(pwd):/files -v $HOME/.kube/config:/.kube/config d3fk/kubectl'
```
You can then run your d3fk/kubectl commands as simple as the following:
```sh
$ k get pods
```
 As the alias was only added in your prompt it is only available for your current session, to make Kubectl available from any future session simply add the alias in your launch shell script e.g `.bashrc`, `.shrc`, `.rc`...
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


## License

The content of this [GitHub code repository](https://github.com/Angatar/kubectl) is provided under **MIT** licence
[![GitHub license](https://img.shields.io/github/license/Angatar/kubectl)](https://github.com/Angatar/kubectl/blob/master/LICENSE).

For the license information related to **kubectl**, please visit  https://github.com/kubernetes/kubectl .


## Interested in Helm?

If you're using Kubectl, you might also find the [d3fk/helm](https://hub.docker.com/r/d3fk/helm/) container useful. It offers a similar lightweight and minimalistic container approach for deploying your Helm charts in your Kubernetes clusters.

For more details and usage instructions, check out the [d3fk/helm GitHub repository](https://github.com/Angatar/helm) or its [Docker Hub page](https://hub.docker.com/r/d3fk/helm/).


[![GitHub license](https://img.shields.io/github/license/Angatar/kubectl)](https://github.com/Angatar/kubectl/blob/master/LICENSE)
