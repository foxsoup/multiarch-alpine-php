#!/bin/bash

export S6_DOWNLOAD_PATH=https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-armhf.tar.gz
export SUPERCRONIC_DOWNLOAD_PATH=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-arm

curl -L $S6_DOWNLOAD_PATH --output /tmp/s6-overlay.tar.gz
curl -L $SUPERCRONIC_DOWNLOAD_PATH --output /tmp/supercronic
