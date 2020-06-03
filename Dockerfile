FROM alpine:latest as helper
MAINTAINER d3fk

RUN  wget  https://storage.googleapis.com/kubernetes-release/release/v1.17.5/bin/linux/amd64/kubectl \
  && chmod +x kubectl 

FROM scratch
COPY --from=helper /kubectl /kubectl

ENTRYPOINT ["/kubectl"]
CMD ["--help"]
WORKDIR /files
