#!/bin/sh

cat >&2 <<'EOF'
########################################################################
#  DEPRECATED: This image contains Helm v3 and is deprecated.          #
#  Please migrate to the v4 variant: ghcr.io/appuio/helm-v4           #
########################################################################
EOF

if [ "$#" -eq 0 ]; then
  exit 0
fi

exec "$@"