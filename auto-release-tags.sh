#!/usr/bin/env bash
set -euo pipefail

# Plan release tags for a PR merge commit.
#
# Usage: auto-release-tags.sh <release_sha>
#
# For every Dockerfile family touched by the release commit, emits
# "<family>_tag" (empty when the tag already points at this commit) and
# "<family>_push" ("true"/"false"). The family tag is the HELM_VERSION from
# the Dockerfile (e.g. v3.22.1); when that tag exists on a different commit,
# a numeric -1..-100 suffix is appended.
#
# Emits to GITHUB_OUTPUT when set (GitHub Actions), stdout otherwise.

[[ $# -ne 1 ]] && { echo "Usage: $0 <release_sha>" >&2; exit 1; }
release_sha="$1"

version_re='^v[0-9]+\.[0-9]+\.[0-9]+([+.-][0-9A-Za-z.-]+)?$'

die() {
  echo "::error::$1" >&2
  exit 1
}

emit() {
  echo "$1"
  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    printf '%s\n' "$1" >>"$GITHUB_OUTPUT"
  fi
}

plan_family() {
  local dockerfile="$1" label="$2"
  [[ -f "$dockerfile" ]] || die "$dockerfile missing in release commit"

  local version
  version="$(awk -F'=' '/^ENV HELM_VERSION=/ {print $2}' "$dockerfile")"
  [[ "$version" =~ $version_re ]] || die "no HELM_VERSION matching $version_re in $dockerfile: '$version'"
  local name="v${version#v}"

  local candidate_commit
  candidate_commit="$(git rev-parse --quiet --verify "refs/tags/${name}^{commit}" || true)"
  if [[ -n "$candidate_commit" ]]; then
    if [[ "$candidate_commit" == "$release_sha" ]]; then
      emit "${label}_tag="
      emit "${label}_push=false"
      return 0
    fi
    local n
    for n in $(seq 1 100); do
      candidate_commit="$(git rev-parse --quiet --verify "refs/tags/${name}-${n}^{commit}" || true)"
      if [[ -z "$candidate_commit" ]]; then
        emit "${label}_tag=${name}-${n}"
        emit "${label}_push=true"
        return 0
      fi
      if [[ "$candidate_commit" == "$release_sha" ]]; then
        emit "${label}_tag="
        emit "${label}_push=false"
        return 0
      fi
    done
    die "no free ${name}-N tag suffix found (1..100)"
  fi
  emit "${label}_tag=${name}"
  emit "${label}_push=true"
}

git rev-parse --quiet --verify "${release_sha}^{commit}" >/dev/null \
  || die "not a commit SHA in this repository: ${release_sha}"

changed="$(git diff --name-only "${release_sha}^" "${release_sha}" 2>/dev/null || true)"

# Match families per explicit path: grep-style "*Dockerfile*" would wrongly
# match Dockerfile.v4 as a v3 change too.
v3=no
v4=no
while IFS= read -r file; do
  case "$file" in
    Dockerfile) v3=yes ;;
    Dockerfile.v4) v4=yes ;;
  esac
done <<<"$changed"

if [[ "$v3" == yes ]]; then
  plan_family Dockerfile v3
fi
if [[ "$v4" == yes ]]; then
  plan_family Dockerfile.v4 v4
fi
