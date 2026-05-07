import { setupManifest } from '@start9labs/start-sdk'
import { long, short, namecoindDependencyDescription } from './i18n'

export const manifest = setupManifest({
  id: 'namecoin-electrumx',
  title: 'Namecoin ElectrumX',
  license: 'MIT',
  packageRepo:
    'https://github.com/mstrofnone/namecoin-electrumx-startos/tree/0.4.x',
  upstreamRepo: 'https://github.com/namecoin/electrumx',
  marketingUrl: 'https://www.namecoin.org/',
  donationUrl: 'https://www.namecoin.org/donate/',
  docsUrls: ['https://github.com/namecoin/electrumx/blob/master/README.rst'],
  description: { short, long },
  volumes: ['main'],
  images: {
    electrumx: {
      source: {
        dockerBuild: {
          buildArgs: {
            ELECTRUMX_BRANCH: 'protocol-1.4.3-v1',
          },
        },
      },
      arch: ['x86_64', 'aarch64'],
    },
  },
  alerts: {
    install: null,
    update: null,
    uninstall: null,
    restore: null,
    start: null,
    stop: null,
  },
  dependencies: {
    namecoind: {
      description: namecoindDependencyDescription,
      optional: false,
      metadata: {
        title: 'Namecoin Core',
        icon: 'https://raw.githubusercontent.com/mstrofnone/namecoin-core-startos/main/icon.png',
      },
    },
  },
})
