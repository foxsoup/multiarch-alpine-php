FROM php:7.4-fpm-alpine3.11

# Get TARGETPLATFORM env var from buildx, set to default of `linux/amd64` if
# it was invoked by a regular `docker build` rather than buildx.
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

EXPOSE 80

# apk install Alpine packages
RUN apk --update upgrade && \
  apk add --no-cache \
  bash \
  git \
&& rm -rf /var/cache/apk/* > /dev/null

# Copy architecture-specific install scripts into container
COPY ./scripts/* /tmp/

# Run correct install script for target architecture
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then /tmp/arm64.sh; else /tmp/amd64.sh; fi

# Install stuff we downloaded plus any platform-agnostic packages
RUN gunzip -c /tmp/s6-overlay.tar.gz | tar -xf - -C / \
  && rm /tmp/s6-overlay.tar.gz

RUN mv /tmp/supercronic /usr/local/bin/supercronic \
  && chmod a+x /usr/local/bin/supercronic

RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && chmod a+x /usr/local/bin/composer

# Mount S6 scripts
ADD ./alpine/root /

ENTRYPOINT ["/init"]
