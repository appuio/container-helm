#!/usr/bin/env bash
set -e -u -o pipefail

helm_version="$(awk -F '=' '/HELM_VERSION=/{print $2}' Dockerfile)"
helmfile_version="$(awk -F '=' '/HELMFILE_VERSION=/{print $2}' Dockerfile)"
sops_version="$(awk -F '=' '/SOPS_VERSION=/{print $2}' Dockerfile)"
kubectl_version="$(awk -F '=' '/KUBECTL_VERSION=/{print $2}' Dockerfile)"

msg="Release $helm_version

- helm: $helm_version
- helmfile: $helmfile_version
- sops: $sops_version
- kubectl: $kubectl_version
"

git tag -s "$helm_version" -m "$msg"
