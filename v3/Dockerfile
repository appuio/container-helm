FROM docker.io/library/alpine:3.11@sha256:cb8a924afdf0229ef7515d9e5b3024e23b3eb03ddbba287f4a19c6ac90b8d221

LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.openshift.s2i.assemble-user=65534:0

ENV HELM_VERSION=v3.1.2 \
    HELMFILE_VERSION=v0.106.3 \
    SOPS_VERSION=v3.5.0

# `git` is used during CI/CD processes
# `openssh` is used to clone git repositories via SSH
# `bash` is used in helm plugin install hooks
RUN apk add --no-cache git openssh bash curl gnupg

RUN set -x \
 && URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
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
 && wget -q -O /bin/sops "https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux" \
 && chmod +x /bin/helmfile /bin/sops \
 && mkdir /app \
 && chmod -R g=u /app

ENV HOME /app

RUN set -x \
 && helm plugin install https://github.com/chartmuseum/helm-push \
 && helm plugin install https://github.com/databus23/helm-diff \
 && helm plugin install https://github.com/fstech/helm-secrets \
 && helm plugin install https://github.com/helm/helm-2to3 \
 && git version \
 && helm version \
 && helm plugin list

COPY s2i/ /usr/libexec/s2i

USER 65534:0
