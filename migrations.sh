#!/bin/bash
set -e

DIRECTION="$1"

case "$DIRECTION" in
    from)
        echo '{"configured": true}'
        ;;
    to)
        echo '{"configured": true}'
        ;;
    *)
        echo "Unknown migration direction: $DIRECTION" >&2
        exit 1
        ;;
esac

exit 0
