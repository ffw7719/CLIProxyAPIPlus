# Build the official CLIProxyAPI release from its public source tag.
ARG CLI_PROXY_API_VERSION=v8.0.53

FROM golang:1.26-bookworm AS builder
ARG CLI_PROXY_API_VERSION
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends build-essential git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "${CLI_PROXY_API_VERSION}" \
    https://github.com/router-for-me/CLIProxyAPI.git .

RUN go mod download

ARG VERSION=8.0.53
ARG COMMIT=none
ARG BUILD_DATE=unknown
RUN CGO_ENABLED=1 GOOS=linux go build -buildvcs=false \
    -ldflags="-s -w -X 'main.Version=${VERSION}' -X 'main.Commit=${COMMIT}' -X 'main.BuildDate=${BUILD_DATE}'" \
    -o ./CLIProxyAPI ./cmd/server/

FROM debian:bookworm
RUN apt-get update && apt-get install -y --no-install-recommends tzdata ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /CLIProxyAPI
COPY --from=builder /app/CLIProxyAPI /CLIProxyAPI/CLIProxyAPI
COPY config.yaml /CLIProxyAPI/config.yaml

WORKDIR /CLIProxyAPI
EXPOSE 8317
ENV TZ=Asia/Shanghai
RUN cp /usr/share/zoneinfo/${TZ} /etc/localtime && echo "${TZ}" > /etc/timezone

CMD ["./CLIProxyAPI"]
