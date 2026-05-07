import { storeJson } from '../fileModels/store.json'
import { i18n } from '../i18n'
import { sdk } from '../sdk'

const { Value, InputSpec } = sdk

export const rpcConfig = sdk.Action.withInput(
  // id
  'rpc-config',

  // metadata
  async () => ({
    name: i18n('Namecoind RPC + Performance'),
    description: i18n(
      'RPC credentials used to talk to namecoind, plus ElectrumX performance tunables.',
    ),
    warning: null,
    allowedStatuses: 'any',
    group: i18n('Configuration'),
    visibility: 'enabled',
  }),

  // input spec
  InputSpec.of({
    rpcUser: Value.text({
      name: i18n('RPC User'),
      description: i18n(
        'Username configured on namecoind via rpcauth. Defaults to "namecoin".',
      ),
      required: true,
      default: 'namecoin',
      placeholder: null,
      patterns: [],
      masked: false,
      generate: null,
      inputmode: 'text',
    }),
    rpcPassword: Value.text({
      name: i18n('RPC Password'),
      description: i18n(
        'Plaintext RPC password matching the rpcauth entry on namecoind.',
      ),
      required: true,
      default: null,
      placeholder: null,
      patterns: [],
      masked: true,
      generate: null,
      inputmode: 'text',
    }),
    cacheMb: Value.number({
      name: i18n('Cache size (MiB)'),
      description: i18n(
        'In-memory cache used during initial chain indexing. Larger = faster sync, more RAM.',
      ),
      required: true,
      default: 400,
      placeholder: null,
      integer: true,
      min: 100,
      max: 16000,
      step: 100,
      units: 'MiB',
    }),
    maxSessions: Value.number({
      name: i18n('Max sessions'),
      description: i18n('Maximum concurrent client connections.'),
      required: true,
      default: 1000,
      placeholder: null,
      integer: true,
      min: 100,
      max: 10000,
      step: 100,
      units: null,
    }),
  }),

  // pre-fill
  async () => {
    const s = await storeJson.read().once()
    return s ?? {}
  },

  // execute
  async ({ effects, input }) => {
    await storeJson.merge(effects, input)
  },
)
