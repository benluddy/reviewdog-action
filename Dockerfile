FROM alpine:3.11

RUN apk add --no-cache \
    git \
    go \
    jq

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    hub

RUN wget -O golangci-lint.tar.gz https://github.com/golangci/golangci-lint/releases/download/v1.26.0/golangci-lint-1.26.0-linux-amd64.tar.gz && \
    echo "59b0e49a4578fea574648a2fd5174ed61644c667ea1a1b54b8082fde15ef94fd  golangci-lint.tar.gz" | sha256sum -c - && \
    tar -tzf golangci-lint.tar.gz | grep /golangci-lint$ | tar -T- -vxzf golangci-lint.tar.gz | xargs -I{} mv {} /usr/bin/ && \
    rm -r golangci-lint*

RUN wget -O reviewdog.tar.gz https://github.com/reviewdog/reviewdog/releases/download/v0.9.17/reviewdog_0.9.17_Linux_x86_64.tar.gz && \
    echo "445f8e1ae9c85a61ed70a03d35c46fc553f74110ceb9cee79b4035193a22627f  reviewdog.tar.gz" | sha256sum -c - && \
    tar -xzf reviewdog.tar.gz reviewdog && \
    rm reviewdog.tar.gz && \
    mv reviewdog /usr/bin/

COPY pr-event.json /
COPY action /usr/bin/

ENTRYPOINT ["golangci-lint", "run"]
