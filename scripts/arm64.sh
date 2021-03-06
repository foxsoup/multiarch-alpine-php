#!/bin/bash

export S6_DOWNLOAD_PATH=https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-armhf.tar.gz
export SUPERCRONIC_DOWNLOAD_PATH=https://github.com/aptible/supercronic/releases/download/v0.1.12/supercronic-linux-arm
export SYMFONY_SECURITY_PATH=https://github.com/fabpot/local-php-security-checker/releases/download/v1.0.0/local-php-security-checker_1.0.0_linux_arm64

curl -L $S6_DOWNLOAD_PATH --output /tmp/s6-overlay.tar.gz
curl -L $SUPERCRONIC_DOWNLOAD_PATH --output /tmp/supercronic
curl -L $SYMFONY_SECURITY_PATH --output /tmp/local-php-security-checker
