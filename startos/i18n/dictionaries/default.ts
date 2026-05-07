export const DEFAULT_LANG = 'en_US'

const dict = {
  // main.ts
  'Starting Namecoin ElectrumX!': 0,
  'Electrum TCP': 1,
  'ElectrumX is ready and accepting connections': 2,
  'ElectrumX is not ready': 3,

  // interfaces.ts
  'Electrum (TCP)': 4,
  'Cleartext Electrum protocol port. Suitable for local LAN clients.': 5,
  'Electrum (SSL)': 6,
  'Electrum protocol over TLS using a self-signed certificate. Use this for connections from outside the local network.': 7,

  // actions/rpcConfig.ts
  'Namecoind RPC + Performance': 8,
  'RPC credentials used to talk to namecoind, plus ElectrumX performance tunables.': 9,
  'Configuration': 10,
  'RPC User': 11,
  'Username configured on namecoind via rpcauth. Defaults to "namecoin".': 12,
  'RPC Password': 13,
  'Plaintext RPC password matching the rpcauth entry on namecoind.': 14,
  'Cache size (MiB)': 15,
  'In-memory cache used during initial chain indexing. Larger = faster sync, more RAM.': 16,
  'Max sessions': 17,
  'Maximum concurrent client connections.': 18,
} as const

/**
 * Plumbing. DO NOT EDIT.
 */
export type I18nKey = keyof typeof dict
export type LangDict = Record<(typeof dict)[I18nKey], string>
export default dict
