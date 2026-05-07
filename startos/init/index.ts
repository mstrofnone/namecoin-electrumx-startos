import { sdk } from '../sdk'
import { setDependencies } from '../dependencies'
import { setInterfaces } from '../interfaces'
import { versionGraph } from '../versions'
import { actions } from '../actions'
import { restoreInit } from '../backups'
import { storeJson } from '../fileModels/store.json'

export const init = sdk.setupInit(
  restoreInit,
  versionGraph,
  setInterfaces,
  setDependencies,
  actions,
  // seed defaults
  sdk.setupOnInit(async (effects, kind) => {
    if (!kind) return
    if (kind === 'install') {
      await storeJson.merge(effects, {
        rpcUser: 'namecoin',
        rpcPassword: '',
        cacheMb: 400,
        maxSessions: 1000,
      })
    } else {
      await storeJson.merge(effects, {})
    }
  }),
)

export const uninit = sdk.setupUninit(versionGraph)
