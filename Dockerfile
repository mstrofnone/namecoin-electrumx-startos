# Stage 1: Build ElectrumX and dependencies
FROM python:3.11-slim-bookworm AS builder

ARG ELECTRUMX_BRANCH=protocol-1.4.3-v1

RUN apt-get update && apt-get install -y \
    build-essential \
    ca-certificates \
    git \
    libleveldb-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Clone the Namecoin ElectrumX fork at the specified branch
RUN git clone --depth 1 --branch ${ELECTRUMX_BRANCH} https://github.com/namecoin/electrumx.git

WORKDIR /build/electrumx

# Install Python dependencies
RUN pip install --no-cache-dir --prefix=/install \
    'aiorpcx>=0.18.1,<0.23' \
    'aiohttp>=3.3' \
    attrs \
    plyvel \
    pylru \
    uvloop

# Install ElectrumX itself
RUN pip install --no-cache-dir --prefix=/install .

# Stage 2: Runtime image
FROM python:3.11-slim-bookworm

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    bash \
    ca-certificates \
    curl \
    jq \
    libleveldb1d \
    libssl3 \
    netcat-openbsd \
    openssl \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Copy Python packages from builder
COPY --from=builder /install /usr/local

# Copy the ElectrumX source for the coin definitions
COPY --from=builder /build/electrumx /opt/electrumx

# Copy wrapper scripts
COPY docker_entrypoint.sh /usr/local/bin/
COPY check-electrum.sh /usr/local/bin/
COPY properties.sh /usr/local/bin/
COPY migrations.sh /usr/local/bin/
COPY reindex.sh /usr/local/bin/
COPY assets/compat/config_spec.yaml /mnt/assets/
COPY assets/compat/config_rules.yaml /mnt/assets/
COPY assets/compat/dependency_config_rules.yaml /mnt/assets/
COPY assets/compat/banner.txt /mnt/assets/

RUN chmod +x /usr/local/bin/docker_entrypoint.sh \
    /usr/local/bin/check-electrum.sh \
    /usr/local/bin/properties.sh \
    /usr/local/bin/migrations.sh \
    /usr/local/bin/reindex.sh

# Create data and SSL certificate directories
RUN mkdir -p /data/electrumx /ssl

EXPOSE 50001 50002

ENTRYPOINT ["tini", "--"]
CMD ["docker_entrypoint.sh"]
