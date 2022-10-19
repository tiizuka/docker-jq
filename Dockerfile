FROM alpine AS builder
RUN apk add -U --no-cache \
            alpine-sdk \
            autoconf \
            automake \
            libtool \
    && git clone https://github.com/stedolan/jq.git \
    && cd jq/ \
    && git submodule update --init \
    && autoreconf -fi \
    && ./configure --with-oniguruma=builtin \
    && make LDFLAGS=-all-static \
    && ls -l ./jq && sha256sum ./jq && ( ldd ./jq ; true ) && file ./jq \
    && apk add -U --no-cache valgrind \
    && tests/jqtest \
    && strip ./jq \
    && ls -l ./jq && sha256sum ./jq && ( ldd ./jq ; true ) && file ./jq \
    && apk add -U --no-cache upx \
    && upx ./jq \
    && ls -l ./jq && sha256sum ./jq && ( ldd ./jq ; true ) && file ./jq \
    && ./jq --version

FROM scratch
COPY --from=builder /jq/jq /usr/bin/jq
ENTRYPOINT ["/usr/bin/jq"]
