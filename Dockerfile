FROM alpine:latest as helper
LABEL org.opencontainers.image.authors="d3fk"
ARG TARGETPLATFORM
RUN apk update \
    && apk add ca-certificates
    && update-ca-certificates
    && version=$(wget -q -O- https://storage.googleapis.com/kubernetes-release/release/stable.txt) &&  platform=$(echo $TARGETPLATFORM |sed 's/\/v[6,7,8]//') && echo $version && echo $platform && url="https://storage.googleapis.com/kubernetes-release/release/$version/bin/$platform/kubectl" && echo $url && wget $url \
    && chmod +x kubectl 

FROM scratch
LABEL org.opencontainers.image.authors="d3fk"
COPY --from=helper /kubectl /kubectl

ENTRYPOINT ["/kubectl"]
CMD ["--help"]
WORKDIR /files
