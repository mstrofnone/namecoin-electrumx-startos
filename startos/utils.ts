// Constants and shared helpers for namecoin-electrumx-startos.

export const tcpPort = 50001
export const sslPort = 50002
export const rpcPort = 8000

export const namecoindRpcPort = 8336

export const dataDir = '/data/electrumx'
export const sslDir = '/ssl'

export const electrumxMounts = (sdk: typeof import('./sdk').sdk) =>
  sdk.Mounts.of().mountVolume({
    volumeId: 'main',
    subpath: null,
    mountpoint: dataDir,
    readonly: false,
  })
