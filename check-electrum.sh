#!/bin/bash
set -e

# Check if ElectrumX is accepting TCP connections on port 50001
if nc -z -w 3 127.0.0.1 50001 2>/dev/null; then
    # Try to get server info via the Electrum protocol
    # Send a JSON-RPC request for server.version
    RESPONSE=$(echo '{"jsonrpc":"2.0","method":"server.version","id":0,"params":["health-check","1.4"]}' | \
        nc -w 5 127.0.0.1 50001 2>/dev/null | head -1) || true

    if echo "$RESPONSE" | jq -e '.result' >/dev/null 2>&1; then
        echo '{"result": "ready"}'
        exit 0
    fi
fi

# Check if ElectrumX RPC is responding (indicates it's running but maybe still syncing)
if nc -z -w 3 127.0.0.1 8000 2>/dev/null; then
    # Try to get session count via RPC
    RPC_RESPONSE=$(echo '{"jsonrpc":"2.0","method":"getinfo","id":0}' | \
        nc -w 5 127.0.0.1 8000 2>/dev/null | head -1) || true

    if echo "$RPC_RESPONSE" | jq -e '.' >/dev/null 2>&1; then
        # Extract sync status if available
        DB_HEIGHT=$(echo "$RPC_RESPONSE" | jq -r '.result.db_height // "unknown"' 2>/dev/null || echo "unknown")
        DAEMON_HEIGHT=$(echo "$RPC_RESPONSE" | jq -r '.result.daemon_height // "unknown"' 2>/dev/null || echo "unknown")

        if [ "$DB_HEIGHT" != "unknown" ] && [ "$DAEMON_HEIGHT" != "unknown" ]; then
            echo "{\"result\": \"loading\", \"message\": \"Indexing blockchain: block ${DB_HEIGHT}/${DAEMON_HEIGHT}\"}"
        else
            echo '{"result": "loading", "message": "ElectrumX is starting up..."}'
        fi
        exit 61  # starting status
    fi
fi

echo '{"result": "starting", "message": "Waiting for ElectrumX to start..."}'
exit 61
