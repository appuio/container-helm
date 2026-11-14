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

Merge a PR labelled `Publish container image` and the release happens automatically:

1. On merge, the `AUTO Release Container Image` workflow creates the release tag(s) for every changed Dockerfile family and dispatches the `Release` / `Release v4` workflows for those tags, publishing `ghcr.io/appuio/helm:<tag>` / `ghcr.io/appuio/helm-v4:<tag>` (plus `:latest` when the tip of `main` was built).
2. The planned release tags are also computed on label changes before the merge, so they are visible in the workflow run log.

Manual fallback (signed tags between releases):

```console
./tag-release.sh
git push --tags
```

Then run the Release workflow on that tag:

```console
gh workflow run Release --ref v3.22.1 -f tag=v3.22.1
```

Note: tags pushed via `GITHUB_TOKEN` do not trigger workflows, which is why the release workflows are dispatched explicitly.

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
