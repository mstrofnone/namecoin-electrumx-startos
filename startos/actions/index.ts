import { sdk } from '../sdk'
import { rpcConfig } from './rpcConfig'

export const actions = sdk.Actions.of().addAction(rpcConfig)
