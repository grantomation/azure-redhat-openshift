# podman build --build-arg GITHUB_RUNNER_VERSION=$(curl -s "https://api.github.com/repos/actions/runner/releases/latest" | jq -r .tag_name | sed 's/^v//') --build-arg HELM_VERSION=$(curl -s "https://api.github.com/repos/helm/helm/releases/latest" | jq -r .tag_name | sed 's/^v//') -t github_runner:local -f ./config_runner_container/Dockerfile .

FROM registry.access.redhat.com/ubi8-minimal:latest

ARG GITHUB_RUNNER_VERSION
ARG HELM_VERSION

LABEL name="aro_config" \
      vendor="none" \
      version="1" \
      release="0" \
      summary="ARO Day 2 configuration" \
      description="This contianer will configure an ARO private cluster"

RUN microdnf install wget tar gzip curl jq && mkdir /data

RUN wget https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz && \
tar xvf oc.tar.gz -C /bin && \
rm -f /bin/README && \
rm -f oc.tar.gz

RUN wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
tar xvf helm-v${HELM_VERSION}-linux-amd64.tar.gz -C /bin linux-amd64/helm --strip-components 1 && \
rm -rf helm-v${HELM_VERSION}-linux-amd64.tar.gz

COPY openshift_operators/* /data/

RUN chmod +x /data/openshift_config.sh

RUN chown -R 1001:0 /data && \
    chmod -R g=u /data

WORKDIR /data

ENV HOME=/data

USER 1001