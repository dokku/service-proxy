FROM golang:1.25.2-alpine AS build

WORKDIR /go/src/github.com/dokku/service-proxy/

ADD https://raw.githubusercontent.com/jpillora/go-tcp-proxy/eac32a19ca1e98da897a0392d182759ad261e096/cmd/tcp-proxy/main.go .

COPY ["go.mod", "go.sum", "/go/src/github.com/dokku/service-proxy/"]

RUN ls -lah && go build -o /go/bin/tcp-proxy

FROM alpine:3.22.1

COPY --from=build /go/bin/tcp-proxy /usr/local/bin/tcp-proxy

COPY entrypoint /usr/local/bin/entrypoint

CMD ["/usr/local/bin/entrypoint"]
