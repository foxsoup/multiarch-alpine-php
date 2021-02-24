FROM php:7.4-fpm-alpine3.11

# Get TARGETPLATFORM env var from buildx, set to default of `linux/amd64` if
# it was invoked by a regular `docker build` rather than buildx.
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

EXPOSE 80

# apk install Alpine packages
RUN apk --update upgrade && \
  apk add \
  bash \
  freetype \
  git \
  icu-libs \
  libwebp \
  libjpeg-turbo \
  libpng \
  libzip \
  mysql-client \
  netcat-openbsd \
  nginx \
  sudo \
&& rm -rf /var/cache/apk/*

# Add/compile useful extensions - note that xdebug should NOT be enabled by default
RUN docker-php-source extract \
  && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS zlib-dev icu-dev pcre-dev libzip-dev freetype-dev libwebp-dev libjpeg-turbo-dev libpng-dev \
  && pecl install apcu redis xdebug \
  && docker-php-ext-enable apcu redis \
  && docker-php-ext-install intl bcmath gd pdo_mysql opcache zip \
  && apk del .phpize-deps \
  && docker-php-source delete \
  && rm -fr /tmp/pear/cache

# Copy architecture-specific install scripts into container
COPY ./scripts/* /tmp/

# Run correct install script for target architecture
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then /tmp/arm64.sh; else /tmp/amd64.sh; fi

# Install stuff we downloaded plus any platform-agnostic packages
RUN gunzip -c /tmp/s6-overlay.tar.gz | tar -xf - -C / \
  && rm /tmp/s6-overlay.tar.gz

RUN mv /tmp/supercronic /usr/local/bin/supercronic \
  && chmod a+x /usr/local/bin/supercronic

RUN mv /tmp/local-php-security-checker /usr/local/bin/local-php-security-checker \
  && chmod a+x /usr/local/bin/local-php-security-checker

RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer \
  && chmod a+x /usr/local/bin/composer

# Mount S6 scripts
ADD ./alpine/root /

ENTRYPOINT ["/init"]
