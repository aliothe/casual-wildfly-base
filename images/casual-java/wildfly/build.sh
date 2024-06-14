#!/usr/bin/env bash

cd "$(dirname "$0")" && \ 
./base/build.sh && \
./test-application/build.sh
