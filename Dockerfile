FROM busybox:latest
MAINTAINER d3fk

RUN  wget --no-check-certificate https://storage.googleapis.com/kubernetes-release/release/v1.17.5/bin/linux/amd64/kubectl \
  && chmod +x kubectl \
  && mv kubectl /usr/sbin/kubectl

ENTRYPOINT ["kubectl"]
CMD ["--help"]
