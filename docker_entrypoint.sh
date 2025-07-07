#!/bin/bash
#exec /bin/start.sh &
#exec /bin/launch-edgestore.sh &
DAOS=$(uname -s | tr '[:upper:]' '[:lower:]')
# echo $DAOS
if [ "$DAOS" == "linux" ]; then
  echo "Running on Linux"
  FNOS="linux"
else
  echo "Running on Mac"
  FNOS="darwin"
fi

DAARCH=$(uname -m | tr '[:upper:]' '[:lower:]')
# echo $DAARCH
if [ "$DAARCH" == "x86_64" ]; then
  echo "Running on x86_64"
  FNARCH="amd64"
  FNSUFFIX="gnu"
elif [ "$DAARCH" == "aarch64" ]; then
  echo "Running on aarch64"
  FNARCH="aarch64"
  FNSUFFIX="gnu"
else
  echo "Running on Raspberry???"
  FNARCH="arm"
  FNSUFFIX="gnueabihf"
fi
# echo $FNOS
# echo $FNARCH

echo "GOTTY_PORT:" $GOTTY_PORT
echo "APP_USER:" $APP_USER
echo "APP_PASSWORD:" $APP_PASSWORD
echo "BITCOIN_RPCCONNECT:" $BITCOIN_RPCCONNECT
echo "BITCOIN_RPCPORT:" $BITCOIN_RPCPORT
echo "BITCOIN_RPCUSER:" $BITCOIN_RPCUSER
echo "BITCOIN_RPCPASSWORD:" $BITCOIN_RPCPASSWORD


# export BITCOIN_RPCCONNECT="bitcoind-testnet.embassy"
# export BITCOIN_RPCPORT=8332

# echo "BITCOIN_RPCCONNECT:" $BITCOIN_RPCCONNECT
# echo "BITCOIN_RPCPORT:" $BITCOIN_RPCPORT

FNVER="28.1"

BTCFN="bitcoin-$FNVER-$FNARCH-linux-$FNSUFFIX.tar.gz"
BTCURL="https://bitcoincore.org/bin/bitcoin-core-$FNVER/$BTCFN"
echo "Got: "$BTCURL

#https://bitcoincore.org/bin/bitcoin-core-27.1/bitcoin-27.1-x86_64-linux-gnu.tar.gz
#https://bitcoincore.org/bin/bitcoin-core-27.1/bitcoin-27.1-arm-linux-gnueabihf.tar.gz

# This is now done in the build phase not the container run phase
# wget -O /tmp/bitcoin.tar.gz $BTCURL
# tar xzf /tmp/bitcoin.tar.gz -C /tmp
# cp /tmp/bitcoin-$FNVER/bin/bitcoin-cli /usr/local/bin

mkdir -p /data/bin
echo 'export PATH=/data/bin:$PATH' >> /root/.bashrc

# if [ -n "${VARIABLE_NAME}" ]; then
#     echo "VARIABLE_NAME is set"
# else
#     echo "VARIABLE_NAME is unset or empty"
# fi

# export APP_USER=$(yq e ".user" /data/start9/config.yaml)
# export APP_PASSWORD=$(yq e ".password" /data/start9/config.yaml)
# export BITCOIN_RPCUSER=$(yq e '.bitcoind-user' /data/start9/config.yaml)
# export BITCOIN_RPCPASSWORD=$(yq e '.bitcoind-password' /data/start9/config.yaml)

echo APP_USER = $APP_USER
echo APP_PASSWORD = $APP_PASSWORD

GOTTY_CREDS=$APP_USER:$APP_PASSWORD

echo GOTTY_CREDS = $GOTTY_CREDS

mkdir -p /data/bin
echo 'export PATH=/data/bin:$PATH' >> /root/.bashrc

exec /usr/bin/gotty --port $GOTTY_PORT -c $GOTTY_CREDS --permit-write --reconnect /bin/bash