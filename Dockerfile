FROM docker.io/library/alpine:3.15@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300

ENV HELM_VERSION=v3.5.3 \
    HELMFILE_VERSION=v0.138.7 \
    SOPS_VERSION=v3.7.1

# `git` is used during CI/CD processes
# `openssh` is used to clone git repositories via SSH
# `bash` is used in helm plugin install hooks
RUN apk add --no-cache git openssh bash curl gnupg make

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
 && wget -q -O /bin/helmfile "https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64" \
 && wget -q -O /bin/sops "https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux" \
 && chmod +x /bin/helmfile /bin/sops \
 && mkdir /app

ENV HOME /app

RUN set -x \
 && helm plugin install https://github.com/aslafy-z/helm-git --version 0.8.1 \
 && helm plugin install https://github.com/chartmuseum/helm-push \
 && helm plugin install https://github.com/databus23/helm-diff \
 && helm plugin install https://github.com/jkroepke/helm-secrets \
 && helm plugin install https://github.com/helm/helm-2to3 \
 && git version \
 && helm version \
 && helm plugin list \
 # Needed otherwise adding repos fails:
 && mkdir -p /app/.config/helm \
 && chown -R 65534 /app \
 && chmod -R g+w /app

USER 65534:0
