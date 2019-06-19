FROM docker.io/library/alpine:3.9@sha256:7746df395af22f04212cd25a92c1d6dbc5a06a0ca9579a229ef43008d4d1302a

LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.openshift.s2i.assemble-user=65534:0

ENV HELM_VERSION=v2.13.1 \
    HELM_HOME=/helm \
    HELMFILE_VERSION=v0.58.0

# `git` is used during CI/CD processes
# `bash` is used in helm plugin install hooks
RUN apk add --no-cache git bash

RUN set -x \
 && URL="https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
 && wget -q -O /tmp/helm.tgz "${URL}" \
 && SHA256SUM=$(wget -q -O - "${URL}.sha256") \
 && cd /tmp \
 && echo "${SHA256SUM}  /tmp/helm.tgz" > /tmp/CHECKSUM \
 && sha256sum -c /tmp/CHECKSUM \
 && tar -xzvf "/tmp/helm.tgz" \
 && ls -la /tmp \
 && cp "/tmp/linux-amd64/helm" /bin/helm \
 && rm -rf /tmp/* \
 && mkdir -p /usr/libexec/s2i \
 && wget -q -O /bin/helmfile "https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64" \
 && chmod +x /bin/helmfile

RUN set -x \
 && helm init --client-only \
 && helm plugin install https://github.com/chartmuseum/helm-push \
 && helm plugin install https://github.com/databus23/helm-diff \
 && chmod -R g+rwX "${HELM_HOME}" \
 && git version \
 && helm version --client \
 && helm plugin list

COPY s2i/ /usr/libexec/s2i
USER 65534:0
