# container-helm

[![License](https://img.shields.io/github/license/appuio/container-helm.svg)](https://github.com/appuio/container-helm/blob/main/LICENSE)

`helm` in a container image.

The built images are available from the GitHub Container Registry:

    ghcr.io/appuio/helm:latest

Provides a container image that can be used in CI/CD pipelines to deploy apps using [Helm][], the Kubernetes package manager.

**NOTE** Image is no longer pushed to Docker Hub. Use the GHCR.io image instead.

## Contents

- `helm`
- `kubectl`
- [helmfile][]
- [helm-push][] plugin
- [helm-diff][] plugin
- [helm-secrets][] plugin
- [helm-git][] plugin
- `git`
- `gpg`
- `jq`
- `yq`


## Build the image

```console
make docker-build
```

## Release Image

Whenever the Helm version was updated, tag a new version:

    ./tag-release.sh
    git push --tags


## Helm v2

Helm v2 has reached EOL.
As such, no new image tags will be pushed.
The last available tag is v2.17.0 on both docker.io and quay.io.


---

> [APPUiO](https://appuio.ch) -
> GitHub [@appuio](https://github.com/appuio) -
> Twitter [@appuio](https://twitter.com/appuio)

[Helm]: https://helm.sh
[helmfile]: https://github.com/roboll/helmfile
[helm-push]: https://github.com/chartmuseum/helm-push
[helm-diff]: https://github.com/databus23/helm-diff
[helm-secrets]: https://github.com/jkroepke/helm-secrets
[helm-git]: https://github.com/aslafy-z/helm-git
