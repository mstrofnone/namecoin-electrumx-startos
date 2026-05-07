export const short = {
  en_US:
    'Electrum protocol server for Namecoin — enables lightweight wallets to verify names and transactions',
}

export const long = {
  en_US: `Namecoin ElectrumX is an Electrum protocol server for the Namecoin blockchain. It indexes the blockchain and serves data to lightweight Electrum-NMC wallet clients, allowing them to verify transactions and perform name lookups without running a full node themselves.

This fork includes Namecoin-specific enhancements:
- Name script indexing for .bit domain lookups
- AuxPoW (merged mining) support with checkpointed truncation
- Protocol v1.4.3 with 1-block name update confirmation via scriptSig chaining
- Optimized MAX_SEND defaults for AuxPoW chains

ElectrumX requires a fully synced, non-pruned Namecoin Core node to function.`,
}

export const namecoindDependencyDescription = {
  en_US:
    'Namecoin ElectrumX requires a fully synced, non-pruned Namecoin Core node to index from.',
}
