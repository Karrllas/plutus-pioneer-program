#!/bin/bash

assets=/workspaces/plutus-pioneer-program/code/Week02/assets
keypath=/workspaces/plutus-pioneer-program/keys
scriptpath=/workspaces/plutus-pioneer-program/code/Week02/lecture
name="$1"
txin="$2"
body="$assets/onchain.txbody"
tx="$assets/onchain.tx"


# Build the transaction
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 2 \
    --tx-in "$txin" \
    --tx-out "$(cat "$keypath/$name.addr") + 10222223 lovelace" \
    --tx-out-reference-script-file "$assets/onchain.plutus" \
    --change-address "$(cat "$keypath/$name.addr")" \
    --out-file "$body"
    
# Sign the transaction
cardano-cli transaction sign \
    --tx-body-file "$body" \
    --signing-key-file "$keypath/$name.skey" \
    --testnet-magic 2 \
    --out-file "$tx"

# Submit the transaction
cardano-cli transaction submit \
    --testnet-magic 2 \
    --tx-file "$tx"

tid=$(cardano-cli transaction txid --tx-file "$tx")
echo "transaction id: $tid"
echo "Cardanoscan: https://preview.cardanoscan.io/transaction/$tid"