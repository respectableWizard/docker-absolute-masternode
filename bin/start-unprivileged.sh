#!/bin/bash
set -x

EXECUTABLE=/usr/local/bin/absoluted
DIR=$HOME/.absolutecore
FILENAME=absolute.conf
FILE=$DIR/$FILENAME
RPCPORT=${RPCPORT:-7209}
PORT=${PORT:-18888}
EXTERNALIP=${EXTERNALIP}
MASTERNODEGENKEY=${MASTERNODEGENKEY}

# create directory and config file if it does not exist yet
if [ ! -e "$FILE" ]; then
    mkdir -p $DIR

    echo "Creating $FILENAME"

    # Seed a random password for JSON RPC server
    cat <<EOF > $FILE
printtoconsole=${PRINTTOCONSOLE:-1}
rpcport=${RPCPORT}
rpcbind=127.0.0.1
rpcallowip=127.0.0.1/32
rpcallowip=172.17.0.0/16
server=1
daemon=0
listen=1
port=${PORT}
listenonion=0
logtimestamps=1
maxconnections=256
masternode=1
discover=0
externalip=${EXTERNALIP}
rpcuser=${RPCUSER:-absoluterpc}
rpcpassword=${RPCPASSWORD:-`dd if=/dev/urandom bs=33 count=1 2>/dev/null | base64`}
masternodeprivkey=${MASTERNODEGENKEY}
EOF
fi

cat $FILE
ls -lah $DIR/

echo "Initialization completed successfully"
exec $EXECUTABLE
