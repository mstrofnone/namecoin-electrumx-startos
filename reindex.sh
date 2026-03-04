#!/bin/bash
set -e

touch /data/electrumx/.reindex

echo '{"version": "0", "message": "ElectrumX will rebuild its index from scratch on the next start. Please restart the service. This process may take several hours.", "value": null, "copyable": false, "qr": false}'
