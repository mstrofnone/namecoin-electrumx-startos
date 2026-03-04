#!/bin/bash
set -euo pipefail

# Signal handler for graceful shutdown
_term() {
    echo "Received SIGTERM, stopping ElectrumX gracefully..."
    if [ -n "${ELECTRUMX_PID:-}" ]; then
        kill -SIGTERM "$ELECTRUMX_PID" 2>/dev/null || true
        # ElectrumX needs time to flush its database
        echo "Waiting for ElectrumX to flush database (up to 5 minutes)..."
        wait "$ELECTRUMX_PID" 2>/dev/null || true
    fi
    exit 0
}

trap _term SIGTERM SIGINT

CONFIG_FILE="/data/electrumx/start9/config.yaml"

# Read Namecoin Core dependency connection info
# These come from the StartOS dependency system
if [ -f "$CONFIG_FILE" ]; then
    NMC_RPC_USER=$(yq e '.namecoind.rpc-user // "namecoin"' "$CONFIG_FILE" 2>/dev/null || echo "namecoin")
    NMC_RPC_PASS=$(yq e '.namecoind.rpc-password // ""' "$CONFIG_FILE" 2>/dev/null || echo "")
    NMC_RPC_HOST=$(yq e '.namecoind.rpc-host // "namecoind.embassy"' "$CONFIG_FILE" 2>/dev/null || echo "namecoind.embassy")
    NMC_RPC_PORT=$(yq e '.namecoind.rpc-port // "8336"' "$CONFIG_FILE" 2>/dev/null || echo "8336")
    CACHE_MB=$(yq e '.performance.cache-mb // 400' "$CONFIG_FILE" 2>/dev/null || echo "400")
    MAX_SESSIONS=$(yq e '.performance.max-sessions // 1000' "$CONFIG_FILE" 2>/dev/null || echo "1000")
    LOG_LEVEL=$(yq e '.log-level // "info"' "$CONFIG_FILE" 2>/dev/null || echo "info")
else
    NMC_RPC_USER="namecoin"
    NMC_RPC_PASS=""
    NMC_RPC_HOST="namecoind.embassy"
    NMC_RPC_PORT="8336"
    CACHE_MB="400"
    MAX_SESSIONS="1000"
    LOG_LEVEL="info"
fi

# Generate self-signed SSL certificate if not present
if [ ! -f /ssl/server.crt ] || [ ! -f /ssl/server.key ]; then
    echo "Generating self-signed SSL certificate..."
    openssl req -x509 -newkey rsa:2048 \
        -keyout /ssl/server.key \
        -out /ssl/server.crt \
        -days 3650 -nodes \
        -subj "/CN=namecoin-electrumx"
fi

# Set ElectrumX environment variables
export COIN=Namecoin
export NET=mainnet
export DB_DIRECTORY=/data/electrumx/db
export DAEMON_URL="http://${NMC_RPC_USER}:${NMC_RPC_PASS}@${NMC_RPC_HOST}:${NMC_RPC_PORT}/"
export SERVICES="tcp://0.0.0.0:50001,ssl://0.0.0.0:50002,rpc://0.0.0.0:8000"
export SSL_CERTFILE=/ssl/server.crt
export SSL_KEYFILE=/ssl/server.key
export ALLOW_ROOT=1
export CACHE_MB="$CACHE_MB"
export MAX_SESSIONS="$MAX_SESSIONS"
export LOG_LEVEL="$LOG_LEVEL"
export DB_ENGINE=leveldb
export BANNER_FILE=/mnt/assets/banner.txt
export REQUEST_TIMEOUT=30
export INITIAL_CONCURRENT=20

# Create database directory
mkdir -p "$DB_DIRECTORY"

# Check for reindex flag
if [ -f /data/electrumx/.reindex ]; then
    echo "Reindex flag detected. Removing existing database..."
    rm -rf "${DB_DIRECTORY:?}"/*
    rm -f /data/electrumx/.reindex
    echo "Database cleared. ElectrumX will rebuild the index from scratch."
fi

echo "Starting Namecoin ElectrumX..."
echo "  COIN:         $COIN"
echo "  NET:          $NET"
echo "  DB_DIRECTORY: $DB_DIRECTORY"
echo "  DAEMON:       ${NMC_RPC_HOST}:${NMC_RPC_PORT}"
echo "  SERVICES:     $SERVICES"
echo "  CACHE_MB:     $CACHE_MB"
echo "  LOG_LEVEL:    $LOG_LEVEL"

# Run ElectrumX
python3 -m electrumx_server &
ELECTRUMX_PID=$!

# Wait for the process
wait "$ELECTRUMX_PID"
