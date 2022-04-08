FROM docker.io/library/alpine:3.15

ENV HELM_VERSION=v3.8.1 \
    HELMFILE_VERSION=v0.143.1 \
    SOPS_VERSION=v3.7.2 \
    KUBECTL_VERSION=v1.23.5

# `git` is used during CI/CD processes
# `openssh` is used to clone git repositories via SSH
# `bash` is used in helm plugin install hooks
# `jq` and `yq` are used in certain pipelines
RUN apk add --no-cache git openssh bash curl gnupg make ca-certificates yq jq

RUN set -x \
 && cd /tmp \
 # Helm
 && URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
 && wget -q -O /tmp/helm.tgz $URL \
 && SHA256SUM=$(wget -q -O - "${URL}.sha256") \
 && echo "${SHA256SUM}  /tmp/helm.tgz" > /tmp/CHECKSUM \
 && sha256sum -c /tmp/CHECKSUM \
 && tar -xzvf /tmp/helm.tgz \
 && cp /tmp/linux-amd64/helm /bin/helm \
 # kubectl
 && URL="https://dl.k8s.io/${KUBECTL_VERSION}/kubernetes-client-linux-amd64.tar.gz" \
 && wget -q -O /tmp/kubectl.tgz $URL \
 && SHA256SUM=$(wget -q -O - "${URL}.sha256") \
 && echo "${SHA256SUM}  /tmp/kubectl.tgz" > /tmp/CHECKSUM \
 && sha256sum -c /tmp/CHECKSUM \
 && tar -xzvf /tmp/kubectl.tgz \
 && mv kubernetes/client/bin/kubectl /bin/kubectl \
 # Helmfile
 && wget -q -O /bin/helmfile "https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64" \
 # Sops
 && wget -q -O /bin/sops "https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux" \
 && chmod +x /bin/helmfile /bin/sops \
 # Cleanup
 && rm -rf /tmp/* \
 && mkdir /app

ENV HOME /app

RUN set -x \
 && helm plugin install https://github.com/aslafy-z/helm-git \
 && helm plugin install https://github.com/chartmuseum/helm-push \
 && helm plugin install https://github.com/databus23/helm-diff \
 && helm plugin install https://github.com/jkroepke/helm-secrets \
 && helm plugin install https://github.com/helm/helm-2to3 \
 && git version \
 && helm version \
 && helm plugin list \
 # Needed otherwise adding repos fails
 && mkdir -p /app/.config/helm \
 && chown -R 65534 /app \
 && chmod -R g+w /app

USER 65534:0
