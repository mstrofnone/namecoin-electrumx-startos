import { FileHelper, z } from '@start9labs/start-sdk'
import { sdk } from '../sdk'

export const shape = z
  .object({
    rpcUser: z.string().catch('namecoin'),
    rpcPassword: z.string().catch(''),
    cacheMb: z.number().catch(400),
    maxSessions: z.number().catch(1000),
  })
  .strip()

export const storeJson = FileHelper.json(
  {
    base: sdk.volumes.main,
    subpath: '/store.json',
  },
  shape,
)
