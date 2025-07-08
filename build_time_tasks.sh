#!/bin/bash

echo "Start Build Time Tasks..."
echo "$TARGETOS : $TARGETARCH : $TARGETVARIANT"

DAOS=$TARGETOS
# echo $DAOS
if [ "$DAOS" == "linux" ]; then
  echo "Running on Linux"
  FNOS="linux"
else
  echo "Running on Mac"
  FNOS="darwin"
fi

DAARCH=$TARGETARCH
# echo $DAARCH
if [ "$DAARCH" == "amd64" ]; then
  echo "Running on x86_64"
  FNARCH="x86_64"
  FNARCH2="amd64"
  FNSUFFIX="gnu"
elif [ "$DAARCH" == "arm64" ]; then
  echo "Running on aarch64"
  FNARCH="aarch64"
  FNARCH2="arm64"
  FNSUFFIX="gnu"
else
  echo "Running on Raspberry???"
  FNARCH="arm"
  FNARCH2="arm"
  FNSUFFIX="gnueabihf"
fi

FNVER="28.1"

BTCFN="bitcoin-$FNVER-$FNARCH-linux-$FNSUFFIX.tar.gz"
BTCURL="https://bitcoincore.org/bin/bitcoin-core-$FNVER/$BTCFN"
echo "Getting Bitcoin: "$BTCURL

sleep 2

#https://bitcoincore.org/bin/bitcoin-core-27.1/bitcoin-28.1-x86_64-linux-gnu.tar.gz
#https://bitcoincore.org/bin/bitcoin-core-27.1/bitcoin-27.1-arm-linux-gnueabihf.tar.gz

wget -O /tmp/bitcoin.tar.gz $BTCURL
tar xzf /tmp/bitcoin.tar.gz -C /tmp
cp /tmp/bitcoin-$FNVER/bin/bitcoin-cli /usr/local/bin
rm -rf /tmp/bitcoin-$FNVER
rm -f /tmp/bitcoin.tar.gz

FNVER="v0.15.0-alpha"

LITFN="lightning-terminal-linux-$FNARCH2-$FNVER.tar.gz"
LITURL="https://github.com/lightninglabs/lightning-terminal/releases/download/$FNVER/$LITFN"
echo "Getting Lightning Terminal: "$LITURL

sleep 2

#https://github.com/lightninglabs/lightning-terminal/releases/download/v0.15.0-alpha/lightning-terminal-linux-arm64-v0.15.0-alpha.tar.gz

wget -O /tmp/lit.tar.gz $LITURL
tar xzf /tmp/lit.tar.gz -C /tmp
cp /tmp/lightning-terminal-linux-$FNARCH2-$FNVER/* /usr/local/bin
rm -rf /tmp/lightning-terminal-linux-$FNARCH2-$FNVER
rm -f /tmp/lit.tar.gz

ORACLEURL="https://lcfx.com/taproot/oracle.$FNARCH2"
echo "Getting Oracle: "$ORACLEURL
wget -O /tmp/oracle $ORACLEURL
cp /tmp/oracle /usr/local/bin
rm -f /tmp/oracle
chmod +x /usr/local/bin/oracle



# --lit-dir=                                                                The main directory where LiT looks for its configuration file. If LiT is running in
#                                                                           'remote' lnd mode, this is also the directory where the TLS certificates and log
#                                                                           files are stored by default. (default: /root/.lit)
# --configfile=                                                             Path to LiT's configuration file. (default: /root/.lit/lit.conf)

echo "End Build Time Tasks..."
sleep 3