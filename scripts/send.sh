#!/bin/bash

keypath="/workspaces/plutus-pioneer-program/keys"
name="$1"
txin="$2"
name2="$3"
amount="$4"
body="/workspaces/plutus-pioneer-program/keys/send.txbody"
tx="/workspaces/plutus-pioneer-program/keys/send.tx"


# Build the transaction
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 2 \
    --tx-in "$txin" \
    --tx-out "$name2 + $amount lovelace" \
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