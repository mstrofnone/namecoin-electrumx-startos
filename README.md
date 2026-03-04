# Namecoin ElectrumX for StartOS

This is the service wrapper for running [Namecoin ElectrumX](https://github.com/namecoin/electrumx) on [StartOS](https://github.com/Start9Labs/start-os). It packages the Namecoin fork of ElectrumX (branch `protocol-1.4.3-v1`) as a `.s9pk` for installation on any StartOS server.

## About

Namecoin ElectrumX is an Electrum protocol server for the Namecoin blockchain. It indexes the chain and serves lightweight Electrum-NMC wallet clients, enabling name lookups, transaction verification, and NMC management without requiring a full node on the client device.

Key features of this fork:
- Name script indexing for `.bit` domain resolution
- AuxPoW (merged mining) support with checkpointed truncation
- Protocol v1.4.3 with 1-block name update confirmation
- Optimized defaults for AuxPoW chains

## Dependencies

**Runtime:** Requires a fully synced, non-pruned Namecoin Core node (`namecoind` on StartOS) with `txindex=1`.

**Build tools:**
- [Docker](https://docs.docker.com/get-docker/) + [Buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://github.com/mikefarah/yq)
- [Rust & Cargo](https://rustup.rs/)
- [start-sdk](https://github.com/Start9Labs/start-os)

Or run `prepare.sh` on a Debian system to install everything automatically.

## Building

```bash
git clone https://github.com/your-username/namecoin-electrumx-startos.git
cd namecoin-electrumx-startos
make        # build for all platforms
make x86    # build for amd64 only
make arm    # build for arm64 only
```

## Installing

### Via Sideload
1. In StartOS, navigate to **System → Sideload Service**
2. Upload `namecoin-electrumx.s9pk`

### Via CLI
```bash
start-cli auth login
start-cli --host https://server-name.local package install namecoin-electrumx.s9pk
```

## Submitting to Start9

1. Test thoroughly on real hardware (Raspberry Pi and/or x86_64)
2. Email `submissions@start9.com` with a link to this repository
3. Start9 builds, tests, and publishes to the Community Beta Registry
4. After beta testing, request production publication

See the [Start9 Community Submission Process](https://docs.start9.com/0.3.5.x/developer-docs/submission).

## Project Structure

```
namecoin-electrumx-startos/
├── Dockerfile                  # Multi-stage build for ElectrumX
├── Makefile                    # Build orchestration
├── manifest.yaml               # StartOS service manifest
├── instructions.md             # User-facing instructions
├── LICENSE                     # MIT license
├── prepare.sh                  # Debian build env setup
├── docker_entrypoint.sh        # Container entrypoint
├── check-electrum.sh           # Health check script
├── properties.sh               # Service properties display
├── migrations.sh               # Version migration handler
├── reindex.sh                  # Rebuild index action
├── icon.png                    # Service icon (256x256)
├── assets/
│   └── compat/
│       ├── config_spec.yaml            # Configuration schema
│       ├── config_rules.yaml           # Configuration constraints
│       ├── dependency_config_rules.yaml # Namecoin Core dependency rules
│       └── banner.txt                  # Banner served to Electrum clients
└── docker-images/              # Built Docker images (generated)
    ├── aarch64.tar
    └── x86_64.tar
```

## License

This wrapper is released under the MIT License. The upstream ElectrumX is also MIT licensed.
