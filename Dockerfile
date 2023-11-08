FROM docker.io/library/alpine:3.18

# renovate: datasource=github-releases depName=helm/helm
ENV HELM_VERSION=v3.13.2
# renovate: datasource=github-releases depName=helmfile/helmfile
ENV HELMFILE_VERSION=v0.158.1
# renovate: datasource=github-releases depName=mozilla/sops
ENV SOPS_VERSION=v3.8.1
# renovate: datasource=github-releases depName=kubernetes/kubernetes
ENV KUBECTL_VERSION=v1.28.3

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
 && HELMFILE_RELEASE_URL="https://github.com/helmfile/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION#v}" \
 && wget -q -O /tmp/helmfile_${HELMFILE_VERSION#v}_linux_amd64.tar.gz "${HELMFILE_RELEASE_URL}_linux_amd64.tar.gz" \
 && wget -q -O /tmp/CHECKSUM "${HELMFILE_RELEASE_URL}_checksums.txt" \
 && sed -i '/_linux_amd64.tar.gz/!d' /tmp/CHECKSUM \
 && sha256sum -c /tmp/CHECKSUM \
 && tar -xzf /tmp/helmfile_${HELMFILE_VERSION#v}_linux_amd64.tar.gz \
 && cp /tmp/helmfile /bin/helmfile \
 # Sops
 && wget -q -O /bin/sops "https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64" \
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
