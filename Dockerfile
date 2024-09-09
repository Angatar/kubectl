ARG APPNAME="kubectl"
FROM --platform=$BUILDPLATFORM alpine:latest as helper
LABEL org.opencontainers.image.authors="d3fk"
ARG TARGETPLATFORM
ARG APPNAME
ARG USERNAME=$APPNAME

RUN apk add --no-cache openssl \
    && DOWNLOAD_PATH="https://storage.googleapis.com/kubernetes-release/release/$(wget -q -O- https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/$(echo $TARGETPLATFORM |sed 's/\/v[6,7,8]//')/kubectl" \
    && wget $DOWNLOAD_PATH \
    && wget $DOWNLOAD_PATH.sha256 \
    # Verify the checksum
    && sum=$(openssl sha256 $APPNAME | awk '{print $2}') \
    && expected_sum=$(cat $APPNAME.sha256 ) \
    && [ "$sum" != "$expected_sum" ] \
    && echo "SHA sum of $APPNAME does not match. Aborting." \
    && exit 1 || echo "Verifying checksum of $APPNAME... Done." \
    # checksum completed
    && chmod +x kubectl \
    # Creating minimal user and group files for default user
    && mkdir -p "/user/etc" \
    && echo "$USERNAME:x:6009:6009:$USERNAME:/:/sbin/nologin" > /user/etc/passwd \
    && echo "$USERNAME:x:6009:"> /user/etc/group

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
COPY --from=helper /user/etc/ /etc/

USER $APPNAME
ENTRYPOINT ["/kubectl"]
CMD ["--help"]
WORKDIR /files
