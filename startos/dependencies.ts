import { sdk } from './sdk'

export const setDependencies = sdk.setupDependencies(async ({ effects }) => ({
  namecoind: {
    kind: 'running',
    versionRange: '>=30.2.0.3:0',
    healthChecks: ['namecoind'],
  },
}))
