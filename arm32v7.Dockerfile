FROM alpine AS builder1

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM --platform=linux/arm/v7 caddy:builder AS builder2

# Add QEMU
COPY --from=builder1 qemu-arm-static /usr/bin

RUN caddy-builder \
    github.com/caddy-dns/cloudflare

FROM --platform=linux/arm/v7 caddy:latest

COPY --from=builder2 /usr/bin/caddy /usr/bin/caddy
