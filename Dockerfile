FROM alpine:latest as helper
LABEL org.opencontainers.image.authors="d3fk"
ARG BUILDPLATFORM
RUN echo "Getting binary for platform $BUILDPLATFORM" |sed 's/\/v[6,7,8]//'
RUN wget https://storage.googleapis.com/kubernetes-release/release/$(wget -q -O- https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/$(echo $BUILDPLATFORM |sed 's/\/v[6,7,8]//')/kubectl \
    && chmod +x kubectl 

FROM scratch
LABEL org.opencontainers.image.authors="d3fk"
COPY --from=helper /kubectl /kubectl

ENTRYPOINT ["/kubectl"]
CMD ["--help"]
WORKDIR /files
