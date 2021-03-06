#!/bin/bash

BRANCH=${1:-"stable"}
REPO=$2
EXPORT_ARGS=$3
FB_ARGS=$4

set -e -x

for ARCH in x86_64 i386; do
        flatpak-builder -v --force-clean --ccache --sandbox --delete-build-dirs \
                --arch=${ARCH} --repo="${REPO}" --default-branch="${BRANCH}" \
                ${FB_ARGS} ${EXPORT_ARGS} "build/q4wine/$ARCH" \
                "ua.org.brezblock.q4wine.yml"
done

flatpak build-commit-from --verbose ${EXPORT_ARGS} \
        --src-ref="app/ua.org.brezblock.q4wine/i386/${BRANCH}" "${REPO}" \
        "runtime/ua.org.brezblock.q4wine.compat32/x86_64/${BRANCH}"

flatpak build-commit-from --verbose ${EXPORT_ARGS} \
        --src-ref="runtime/ua.org.brezblock.q4wine.Debug/i386/${BRANCH}" "${REPO}" \
        "runtime/ua.org.brezblock.q4wine.compat32.Debug/x86_64/${BRANCH}"
