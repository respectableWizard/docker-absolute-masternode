#!/bin/bash
set -x

USER=absolute
chown -R ${USER} /usr/local/bin/absolute*
chmod 777 /usr/local/bin/"$@"
exec gosu ${USER} "/usr/local/bin/$@"