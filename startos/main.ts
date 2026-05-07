import { storeJson } from './fileModels/store.json'
import { i18n } from './i18n'
import { sdk } from './sdk'
import {
  dataDir,
  electrumxMounts,
  namecoindRpcPort,
  rpcPort,
  sslDir,
  sslPort,
  tcpPort,
} from './utils'

export const main = sdk.setupMain(async ({ effects }) => {
  console.info(i18n('Starting Namecoin ElectrumX!'))

  const store = await storeJson.read().const(effects)
  if (!store) {
    throw new Error('No store')
  }

  // Find the namecoind container so ElectrumX can talk to its RPC.
  const namecoindIp = await sdk
    .getContainerIp(effects, { packageId: 'namecoind' })
    .const()

  if (!namecoindIp) {
    throw new Error(
      'namecoind container IP not available — is the dependency installed and running?',
    )
  }

  const electrumxSub = await sdk.SubContainer.of(
    effects,
    { imageId: 'electrumx' },
    electrumxMounts(sdk),
    'electrumx-sub',
  )

  // Generate self-signed SSL cert if missing.
  await electrumxSub.execFail(['mkdir', '-p', sslDir, `${dataDir}/db`], {
    user: 'root',
  })
  await electrumxSub.execFail(
    [
      'sh',
      '-c',
      `if [ ! -f ${sslDir}/server.crt ] || [ ! -f ${sslDir}/server.key ]; then ` +
        `openssl req -x509 -newkey rsa:2048 ` +
        `-keyout ${sslDir}/server.key ` +
        `-out ${sslDir}/server.crt ` +
        `-days 3650 -nodes ` +
        `-subj "/CN=namecoin-electrumx"; fi`,
    ],
    { user: 'root' },
  )

  const daemonUrl = `http://${store.rpcUser}:${encodeURIComponent(
    store.rpcPassword,
  )}@${namecoindIp}:${namecoindRpcPort}/`

  const env: Record<string, string> = {
    COIN: 'Namecoin',
    NET: 'mainnet',
    DB_DIRECTORY: `${dataDir}/db`,
    DAEMON_URL: daemonUrl,
    SERVICES: `tcp://0.0.0.0:${tcpPort},ssl://0.0.0.0:${sslPort},rpc://0.0.0.0:${rpcPort}`,
    SSL_CERTFILE: `${sslDir}/server.crt`,
    SSL_KEYFILE: `${sslDir}/server.key`,
    ALLOW_ROOT: '1',
    CACHE_MB: String(store.cacheMb),
    MAX_SESSIONS: String(store.maxSessions),
  }

  return sdk.Daemons.of(effects).addDaemon('electrumx', {
    subcontainer: electrumxSub,
    exec: {
      command: ['electrumx_server'],
      env,
    },
    ready: {
      display: i18n('Electrum TCP'),
      fn: () =>
        sdk.healthCheck.checkPortListening(effects, tcpPort, {
          successMessage: i18n('ElectrumX is ready and accepting connections'),
          errorMessage: i18n('ElectrumX is not ready'),
        }),
    },
    requires: [],
  })
})
