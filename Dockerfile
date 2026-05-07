# Build stage: install Namecoin ElectrumX from a pinned upstream branch.
FROM python:3.11-slim-bookworm AS builder

ARG ELECTRUMX_BRANCH=protocol-1.4.3-v1

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        git \
        libleveldb-dev \
        libssl-dev \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone --depth 1 --branch ${ELECTRUMX_BRANCH} \
        https://github.com/namecoin/electrumx.git src

WORKDIR /build/src

RUN pip install --no-cache-dir --prefix=/install \
        'aiorpcx>=0.18.1,<0.23' \
        'aiohttp>=3.3' \
        attrs \
        plyvel \
        pylru \
        uvloop

RUN pip install --no-cache-dir --prefix=/install .

# Final image
FROM python:3.11-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libleveldb1d \
        libssl3 \
        netcat-openbsd \
        openssl \
        tini \
        && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local
COPY --from=builder /build/src /opt/electrumx

# TCP, SSL, internal RPC
EXPOSE 50001 50002 8000

ENTRYPOINT ["tini", "--"]
