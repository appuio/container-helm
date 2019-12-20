FROM docker.io/library/alpine:3.11@sha256:d371657a4f661a854ff050898003f4cb6c7f36d968a943c1d5cde0952bd93c80

LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.openshift.s2i.assemble-user=65534:0

ENV HELM_VERSION=v2.16.1 \
    HELM_HOME=/helm \
    HELMFILE_VERSION=v0.92.0 \
    SOPS_VERSION=3.4.0

# `git` is used during CI/CD processes
# `openssh` is used to clone git repositories via SSH
# `bash` is used in helm plugin install hooks
RUN apk add --no-cache git openssh bash curl gnupg

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
 && wget -q -O /bin/sops "https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux" \
 && chmod +x /bin/helmfile /bin/sops

RUN set -x \
 && helm init --client-only \
 && helm plugin install https://github.com/chartmuseum/helm-push \
 && helm plugin install https://github.com/databus23/helm-diff \
 && helm plugin install https://github.com/futuresimple/helm-secrets \
 && chmod -R g+rwX "${HELM_HOME}" \
 && git version \
 && helm version --client \
 && helm plugin list

COPY s2i/ /usr/libexec/s2i

RUN mkdir /app && chmod -R g=u /app

ENV HOME /app

USER 65534:0
