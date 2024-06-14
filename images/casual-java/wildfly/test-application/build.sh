#!/usr/bin/env bash

cd "$(dirname "$0")" && \
docker build . -t wildfly-casual-java-test-application
