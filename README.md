# Namecoin ElectrumX for StartOS (0.4.x)

Wrapper that builds the [Namecoin ElectrumX](https://github.com/namecoin/electrumx) Electrum protocol server as a StartOS v0.4.x service package (`.s9pk`).

This branch (`0.4.x`) targets StartOS v0.4.x with the TypeScript SDK.
For the v0.3.5.x branch, see [`main`](https://github.com/mstrofnone/namecoin-electrumx-startos/tree/main).

## Versions

- **Namecoin ElectrumX:** `protocol-1.4.3-v1` (1-block name update confirmation, AuxPoW support)
- **StartOS:** v0.4.0+
- **Hard dependency:** `namecoind >= 30.2.0.3:0` (see [namecoin-core-startos](https://github.com/mstrofnone/namecoin-core-startos))

## Ports

- `50001/tcp` — Electrum protocol (cleartext)
- `50002/tcp` — Electrum protocol (TLS, self-signed cert)
- `8000/tcp` — internal RPC (not exposed externally)

## Configuration

After install, open the **Namecoind RPC + Performance** action and set the `rpcuser` / `rpcpassword` matching an `rpcauth=` line on namecoind. ElectrumX talks to namecoind over the dependency container IP.

## Build

```bash
make           # all arches
make x86       # x86_64 only
make arm       # aarch64 only
```

## License

MIT
