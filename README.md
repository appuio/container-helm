# container-helm

[![dockeri.co](http://dockeri.co/image/appuio/helm)](https://hub.docker.com/r/appuio/helm/)

[![Build Status](https://img.shields.io/docker/cloud/build/appuio/helm.svg)](https://hub.docker.com/r/appuio/helm/builds
) [![GitHub issues](https://img.shields.io/github/issues-raw/appuio/container-helm.svg)](https://github.com/appuio/container-helm/issues
) [![GitHub PRs](https://img.shields.io/github/issues-pr-raw/appuio/container-helm.svg)](https://github.com/appuio/container-helm/pulls
) [![License](https://img.shields.io/github/license/appuio/container-helm.svg)](https://github.com/appuio/container-helm/blob/master/LICENSE)


`helm` in a container image.

The built images are available from [Docker Hub][hub]

Provides a container image that can be used in CI/CD pipelines to deploy apps using [Helm][], the Kubernetes package manager.

## Contents

- `helm`
- [helmfile][]
- [helm-push][] plugin
- [helm-diff][] plugin
- [helm-secrets][] plugin
- [helm-git][] plugin
- `git`
- `gpg`


> [APPUiO](https://appuio.ch) -
> GitHub [@appuio](https://github.com/appuio) -
> Twitter [@appuio](https://twitter.com/appuio)

[hub]: https://hub.docker.com/r/appuio/helm/
[Helm]: https://helm.sh
[helmfile]: https://github.com/roboll/helmfile
[helm-push]: https://github.com/chartmuseum/helm-push
[helm-diff]: https://github.com/databus23/helm-diff
[helm-secrets]: https://github.com/futuresimple/helm-secrets
[helm-git]: https://github.com/aslafy-z/helm-git

## Build the image

```console
docker build -f v3/Dockerfile
docker build -f v2/Dockerfile
```
