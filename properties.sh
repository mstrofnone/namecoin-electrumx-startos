#!/bin/bash
set -e

# Try to get info from the ElectrumX RPC interface
RPC_INFO=$(echo '{"jsonrpc":"2.0","method":"getinfo","id":0}' | \
    nc -w 5 127.0.0.1 8000 2>/dev/null | head -1) || RPC_INFO="{}"

DB_HEIGHT=$(echo "$RPC_INFO" | jq -r '.result.db_height // "N/A"' 2>/dev/null || echo "N/A")
DAEMON_HEIGHT=$(echo "$RPC_INFO" | jq -r '.result.daemon_height // "N/A"' 2>/dev/null || echo "N/A")
SESSIONS=$(echo "$RPC_INFO" | jq -r '.result.sessions // "N/A"' 2>/dev/null || echo "N/A")
VERSION=$(echo "$RPC_INFO" | jq -r '.result.version // "N/A"' 2>/dev/null || echo "N/A")

# Calculate sync percentage
if [ "$DB_HEIGHT" != "N/A" ] && [ "$DAEMON_HEIGHT" != "N/A" ] && [ "$DAEMON_HEIGHT" != "0" ]; then
    SYNC_PCT=$(echo "$DB_HEIGHT $DAEMON_HEIGHT" | awk '{printf "%.2f", ($1 / $2) * 100}')
else
    SYNC_PCT="N/A"
fi

# Get database size
if [ -d /data/electrumx/db ]; then
    DB_SIZE=$(du -sh /data/electrumx/db 2>/dev/null | cut -f1 || echo "N/A")
else
    DB_SIZE="N/A"
fi

cat <<EOF
version: 2
data:
  Connection Info:
    type: object
    value:
      Electrum TCP Port:
        type: string
        value: "50001"
        description: Plaintext Electrum protocol port
        copyable: true
        masked: false
        qr: false
      Electrum SSL Port:
        type: string
        value: "50002"
        description: SSL-encrypted Electrum protocol port
        copyable: true
        masked: false
        qr: false
  Sync Status:
    type: object
    value:
      ElectrumX Version:
        type: string
        value: "${VERSION}"
        description: ElectrumX server version
        copyable: false
        masked: false
        qr: false
      Index Height:
        type: string
        value: "${DB_HEIGHT}"
        description: Current indexed block height
        copyable: false
        masked: false
        qr: false
      Daemon Height:
        type: string
        value: "${DAEMON_HEIGHT}"
        description: Namecoin Core block height
        copyable: false
        masked: false
        qr: false
      Sync Progress:
        type: string
        value: "${SYNC_PCT}%"
        description: Index synchronization progress
        copyable: false
        masked: false
        qr: false
      Active Sessions:
        type: string
        value: "${SESSIONS}"
        description: Number of connected Electrum clients
        copyable: false
        masked: false
        qr: false
      Database Size:
        type: string
        value: "${DB_SIZE}"
        description: Size of the ElectrumX index database
        copyable: false
        masked: false
        qr: false
EOF
