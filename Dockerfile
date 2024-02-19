FROM golang:1.21-alpine3.19 AS build-env

ARG CGO_EXTRA_CFLAGS

RUN apk --no-cache add \
    build-base \
    git \
    nodejs \
    npm \
    && rm -rf /var/cache/apk/*

COPY ./ /app
WORKDIR /app

RUN TAGS="bindata" make build

RUN go build contrib/environment-to-ini/environment-to-ini.go

COPY docker/root /tmp/local

RUN chmod 755 /tmp/local/usr/bin/entrypoint \
              /tmp/local/usr/local/bin/gitea \
              /tmp/local/etc/s6/gitea/* \
              /tmp/local/etc/s6/openssh/* \
              /tmp/local/etc/s6/.s6-svscan/* \
              /app/gitea \
              /app/environment-to-ini
RUN chmod 644 /app/contrib/autocompletion/bash_autocomplete


FROM alpine:3.19

EXPOSE 22 3000

RUN apk --no-cache add \
    bash \
    ca-certificates \
    curl \
    gettext \
    git \
    linux-pam \
    openssh \
    s6 \
    sqlite \
    su-exec \
    gnupg \
    && rm -rf /var/cache/apk/*

RUN addgroup -S -g 1000 git && \
    adduser -S -H -D -h /data/git -s /bin/bash -u 1000 -G git git && \
    echo "git:*" | chpasswd -e

ENV USER=git

ENV GITEA_CUSTOM /data/gitea

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]

COPY --from=build-env /tmp/local /
COPY --from=build-env /app /app/gitea
COPY --from=build-env /app/environment-to-ini /usr/local/bin/environment-to-ini
COPY --from=build-env /app/contrib/autocompletion/bash_autocomplete /etc/profile.d/gitea_bash_autocomplete.sh
