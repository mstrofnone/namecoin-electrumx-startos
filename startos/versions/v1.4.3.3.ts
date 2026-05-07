import { VersionInfo, IMPOSSIBLE } from '@start9labs/start-sdk'

export const v_1_4_3_3 = VersionInfo.of({
  version: '1.4.3.3:0',
  releaseNotes: {
    en_US:
      'Initial StartOS v0.4.x release. Ported the v0.3.5 wrapper to the TypeScript SDK. Targets Namecoin Core v30.2.0.3 (v0.4.x) as a hard dependency.',
  },
  migrations: {
    up: async ({ effects }) => {},
    down: IMPOSSIBLE,
  },
})
