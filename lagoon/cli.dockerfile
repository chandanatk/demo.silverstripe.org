FROM amazeeio/php:7.4-cli-drupal

RUN set -xe \
    && apk add --update \
        icu \
    && apk add --no-cache --virtual .php-deps \
        make \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        zlib-dev \
        icu-dev \
        g++ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install \
        intl \
    && docker-php-ext-enable intl \
    && { find /usr/local/lib -type f -print0 | xargs -0r strip --strip-all -p 2>/dev/null || true; } \
    && apk del .build-deps \
    && rm -rf /tmp/* /usr/local/lib/php/doc/* /var/cache/apk/*

ENV SS_DEFAULT_ADMIN_USERNAME="admin"
ENV SS_DEFAULT_ADMIN_PASSWORD="lag00n"
ENV TEMP_FOLDER="/app/public/assets/tmp"

# Copy sliverstripe config entrypoint
COPY lagoon/ss-config.sh /lagoon/entrypoints/90-ss-config.sh
RUN echo "source /lagoon/entrypoints/90-ss-config.sh" >> /home/.bashrc

COPY composer.json composer.lock /app/
RUN composer install --no-dev \
    && mkdir -p app/public/assets
COPY . /app
RUN composer vendor-expose copy

# Define where the Drupal Root is located
ENV WEBROOT=public
