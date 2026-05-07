import { i18n } from './i18n'
import { sdk } from './sdk'
import { sslPort, tcpPort } from './utils'

export const setInterfaces = sdk.setupInterfaces(async ({ effects }) => {
  // TCP (cleartext Electrum protocol)
  const tcpMulti = sdk.MultiHost.of(effects, 'electrum-tcp')
  const tcpOrigin = await tcpMulti.bindPort(tcpPort, {
    protocol: null,
    preferredExternalPort: tcpPort,
    addSsl: null,
    secure: { ssl: false },
  })
  const tcp = sdk.createInterface(effects, {
    name: i18n('Electrum (TCP)'),
    id: 'electrum-tcp',
    description: i18n(
      'Cleartext Electrum protocol port. Suitable for local LAN clients.',
    ),
    type: 'api',
    masked: false,
    schemeOverride: null,
    username: null,
    path: '',
    query: {},
  })
  const tcpReceipt = await tcpOrigin.export([tcp])

  // SSL (Electrum protocol over TLS, with self-signed cert)
  const sslMulti = sdk.MultiHost.of(effects, 'electrum-ssl')
  const sslOrigin = await sslMulti.bindPort(sslPort, {
    protocol: null,
    preferredExternalPort: sslPort,
    addSsl: null,
    secure: { ssl: true },
  })
  const ssl = sdk.createInterface(effects, {
    name: i18n('Electrum (SSL)'),
    id: 'electrum-ssl',
    description: i18n(
      'Electrum protocol over TLS using a self-signed certificate. Use this for connections from outside the local network.',
    ),
    type: 'api',
    masked: false,
    schemeOverride: null,
    username: null,
    path: '',
    query: {},
  })
  const sslReceipt = await sslOrigin.export([ssl])

  return [tcpReceipt, sslReceipt]
})
