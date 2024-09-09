ARG APPNAME="kubectl"
FROM --platform=$BUILDPLATFORM alpine:latest as helper
LABEL org.opencontainers.image.authors="d3fk"
ARG TARGETPLATFORM
ARG USERNAME=$APPNAME
RUN wget https://storage.googleapis.com/kubernetes-release/release/$(wget -q -O- https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/$(echo $TARGETPLATFORM |sed 's/\/v[6,7,8]//')/kubectl \
    && chmod +x kubectl \
    # Creating minimal user and group files for default user
    && mkdir -p "${APPNAME}USER/etc" \
    && echo "$USERNAME:x:6009:6009:$USERNAME:/:/sbin/nologin" > ${APPNAME}USER/etc/passwd \
    && echo "$USERNAME:x:6009:"> ${APPNAME}USER/etc/group

FROM scratch
ARG APPNAME
LABEL org.opencontainers.image.authors="d3fk"
LABEL org.opencontainers.image.source="https://github.com/Angatar/$APPNAME.git"
LABEL org.opencontainers.image.url="https://github.com/Angatar/$APPNAME"
LABEL org.opencontainers.image.base.name="docker.io/library/scratch"
LABEL org.opencontainers.image.title="d3fk/$APPNAME"
LABEL org.opencontainers.image.description="Minimal container image only embedding \
Kubectl official binary from Scratch, really useful to manage kubernetes clusters \
from any docker related environment : containers, pods, cronjobs ..."
COPY --from=helper /kubectl /kubectl
COPY --from=helper ${APPNAME}USER/etc /etc

USER $APPNAME
ENTRYPOINT ["/kubectl"]
CMD ["--help"]
WORKDIR /files
