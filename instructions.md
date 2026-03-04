# Namecoin ElectrumX - Instructions

## What is Namecoin ElectrumX?

ElectrumX is an Electrum protocol server for the Namecoin blockchain. It indexes the chain and serves data to lightweight Electrum-NMC wallet clients, enabling them to look up names, verify transactions, and manage NMC without running a full node on their device.

This is the Namecoin fork of ElectrumX, which adds support for name scripts, AuxPoW merged mining, and Protocol v1.4.3 features including 1-block name update confirmation.

## Requirements

- **Namecoin Core**: ElectrumX requires a fully synced, **non-pruned** Namecoin Core node with the transaction index (`txindex=1`) enabled. StartOS will enforce this dependency automatically.
- **RAM**: At least 1 GB of free RAM during initial sync. The `Cache Size` setting in Config controls ongoing memory usage.

## Initial Sync

On first start, ElectrumX must build its index from the Namecoin blockchain data in your Namecoin Core node. This can take several hours depending on your hardware. You can monitor progress in the **Properties** tab.

## Connecting Wallets

### Electrum-NMC

To connect Electrum-NMC to your ElectrumX server:

1. Open Electrum-NMC
2. Go to **Tools → Network → Server**
3. Uncheck "Select server automatically"
4. Enter your ElectrumX Tor address (found in **Properties**) and port `50001` (TCP) or `50002` (SSL)
5. Click Close

### Other Electrum-Protocol Clients

Any wallet or tool that speaks the Electrum protocol and supports Namecoin can connect using the TCP (50001) or SSL (50002) ports shown in the **Properties** tab.

## Configuration

### Cache Size

Controls memory allocated to caching during sync and operation. Larger values speed up initial sync but consume more RAM. Do not set this above 60% of your available physical RAM.

### Max Sessions

Limits the number of concurrent Electrum client connections. The default of 1000 is suitable for personal use.

### Log Level

Controls verbosity of log output. Use "debug" for troubleshooting, "info" for normal operation.

## Actions

### Rebuild Index

If ElectrumX gets into a bad state, you can use the **Rebuild Index** action to delete the database and reindex from scratch. This will make ElectrumX unavailable until the reindex completes.

## Support

- [Namecoin Forum](https://forum.namecoin.org/)
- [Namecoin ElectrumX GitHub](https://github.com/namecoin/electrumx/issues)
- [Namecoin Chat](https://www.namecoin.org/resources/chat/)
