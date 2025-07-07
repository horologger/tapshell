#!/bin/bash

echo "Start Build Bitcoin Configuration..."
echo "$BITCOIN_RPCUSER:$BITCOIN_RPCPASSWORD  $BITCOIN_RPCCONNECT:$BITCOIN_RPCPORT"

mkdir -p ~/.bitcoin
echo 'rpcuser='$BITCOIN_RPCUSER > ~/.bitcoin/bitcoin.conf
echo 'rpcpassword='$BITCOIN_RPCPASSWORD >> ~/.bitcoin/bitcoin.conf
echo 'rpcconnect='$BITCOIN_RPCCONNECT >> ~/.bitcoin/bitcoin.conf
echo 'rpcport='$BITCOIN_RPCPORT >> ~/.bitcoin/bitcoin.conf
