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
This container was created to be used from a K8s CronJob in order to schedule forced rolling updates of specific deployments so that our related scaled applications can gain in stablility by restarting pods regularly with fresh containers with no downtime.

In order to illustrate the following descriptions and for testing purposes, template YAML files have been placed in the k8s directory of this repo.

Rolling updates of your pods can simply be triggered by patching your targeted deployment ... it is important to define a rolling-update strategy to be sure that it will trigger the wished rolling-update behavior while patching your deployment, ex:
```yaml
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1 # how many pods we can add at a time
      maxUnavailable: 1 # how many pods can be unavailable during the rolling update
```
A complete template deployment file is available from the k8s directory: [test-deployment.yaml](https://github.com/Angatar/kubectl-from-busybox/blob/master/k8s/test-deployment.yaml)

The default kubectl RBAC rules do not allow to run a patch from another pod. So, to make it works we have to create a RBAC Role and RoleBinding with the rights to "get" and "patch". 

For testing purposes and as we are creating a dedicated RBAC Role and RoleBinding we will work on a dedicated namespace "r-updated" so that these modifications won't touch your current default namespace and will only apply to the targeted deployments for regular rolling-updates (the CronJob and the targeted deployments as well as the dedicated RBAC rules have to be in the same namespace). If you want to apply these changes to an existing namespace you'll have to edit the namespace line in the provided templates for the deployment, rbac, configmap and cronjob. Otherwise you simply have to create the "r-updated" namespace:  

```sh
$ kubectl create namespace r-updated
```
The template RBAC yaml file containing the required Role and RoleBinding to create a rolling update is available from the k8s directory of the repo as well ([rbac-rupdate.yaml](https://github.com/Angatar/kubectl-from-busybox/blob/master/k8s/rbac-rupdate.yaml))... please adapt the rights, and namespaces to your needs.

```sh
$ kubectl create -f rbac-rupdate.yaml
```
A configmap to be used with your pod/job/cronjob that will make use of the d3fk/kubectl container ... can easily be created from the .kube/config file with the following kubectl command (assuming your config file of interest is located at $HOME/.kube ):

```sh
$ kubectl create configmap kubeconfig --namespace r-updated --from-file $HOME/.kube
```
    
You can use the provided YAML file ([rolling-update-cronjob.yaml](https://github.com/Angatar/kubectl-from-busybox/blob/master/k8s/rolling-update-cronjob.yaml)) available from the k8s directory in this repo as a template for your CronJob (for test purposes this cronjob will trigger a job every minute, you'll have to adapt the cron settings to your needs).

This template CronJob yaml file is using the configmap "kubeconfig" created previously to load the kubectl configuration file (change this to your requirements). Once configured with the targeted deployment (simply edit the deployment name in the CronJob file), the k8s CronJob can be created from the file:
```sh
kubectl create -f rolling-update-cronjob.yaml
```
Then, k8s rolling updates will be made regularly based on your CronJob configuration.
