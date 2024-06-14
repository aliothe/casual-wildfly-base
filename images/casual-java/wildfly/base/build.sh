#!/usr/bin/env bash
#-*- coding: utf-8-unix -*-

cd "$(dirname "$0")" && \
docker build --no-cache . -t casual-wildfly-base
