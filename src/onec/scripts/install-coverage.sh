#!/bin/bash
set -e

coverageFile="/tmp/Coverage41C.tar"

if [[ ! -f "${coverageFile}" ]]; then
    echo "downloading coverage release"
    wget -q -O Coverage41C.tar https://github.com/1c-syntax/Coverage41C/releases/download/v${COVERAGE_VERSION}/Coverage41C-${COVERAGE_VERSION}.tar
else
    echo "Coverage release found in /tmp"
fi

tar -xf /tmp/Coverage41C.tar \
    && mkdir /Coverage41C \
    && cp -r /tmp/Coverage41C*/* /Coverage41C/ \
    && rm -rf /tmp/Coverage41C* \
    && ln -s /Coverage41C/bin/Coverage41C /usr/bin/Coverage41C