FROM golang:1.11.3 as builder

EXPOSE 8080
ENV VERSION 1.5.1
ENV BUILD_DIR /build

RUN mkdir -p ${BUILD_DIR}
WORKDIR ${BUILD_DIR}

COPY go.* ./
RUN go mod download
COPY . .

RUN go test -cover ./...
RUN CGO_ENABLED=0 go build -a -tags netgo -installsuffix netgo -ldflags "-X github.com/halverneus/static-file-server/cli/version.version=${VERSION}" -o /serve /build/bin/serve

FROM scratch
COPY --from=builder /serve /
ENTRYPOINT ["/serve"]
CMD []

# Metadata
LABEL life.apets.vendor="Halverneus" \
      life.apets.url="https://github.com/halverneus/static-file-server" \
      life.apets.name="Static File Server" \
      life.apets.description="A tiny static file server" \
      life.apets.version="v1.5.1" \
      life.apets.schema-version="1.0"
