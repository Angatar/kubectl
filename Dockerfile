FROM --platform=$BUILDPLATFORM alpine:latest as helper
LABEL org.opencontainers.image.authors="d3fk"
ARG KUBEVERSION="v1.26.8"
ARG TARGETPLATFORM
RUN wget https://storage.googleapis.com/kubernetes-release/release/$KUBEVERSION/bin/$(echo $TARGETPLATFORM |sed 's/\/v[6,7,8]//')/kubectl \
  && chmod +x kubectl 

FROM scratch
LABEL org.opencontainers.image.authors="d3fk"
COPY --from=helper /kubectl /kubectl

ENTRYPOINT ["/kubectl"]
CMD ["--help"]
WORKDIR /files
