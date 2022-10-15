FROM curlimages/curl AS builder
RUN curl -L -o /tmp/jq \
      https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
    chmod a+x /tmp/jq

FROM scratch
COPY --from=builder /tmp/jq /usr/bin/jq
ENTRYPOINT ["/usr/bin/jq"]
