import { sdk } from './sdk'

// ElectrumX rebuilds its db from namecoind quickly, so we exclude db/ from
// backups and only persist the small store.json + ssl certs.
export const { createBackup, restoreInit } = sdk.setupBackups(async () =>
  sdk.Backups.ofVolumes('main').setOptions({
    exclude: ['db/'],
  }),
)
