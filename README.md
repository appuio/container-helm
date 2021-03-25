# container-helm

[![Build Status](https://img.shields.io/github/workflow/status/appuio/container-helm/Master)](https://github.com/vshn/k8up/actions/workflows/master.yml)
[![License](https://img.shields.io/github/license/appuio/container-helm.svg)](https://github.com/appuio/container-helm/blob/master/LICENSE)

`helm` in a container image.

The built images are available from

* [Docker Hub][hub]
* [Quay.io][quay]

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
[quay]: https://quay.io/repository/appuio/helm
[Helm]: https://helm.sh
[helmfile]: https://github.com/roboll/helmfile
[helm-push]: https://github.com/chartmuseum/helm-push
[helm-diff]: https://github.com/databus23/helm-diff
[helm-secrets]: https://github.com/jkroepke/helm-secrets
[helm-git]: https://github.com/aslafy-z/helm-git

## Build the image

```console
make docker-build
```

## Helm v2

Helm v2 has reached EOL.
As such, no new image tags will be pushed.
The last available tag is v2.17.0 on both docker.io and quay.io.
