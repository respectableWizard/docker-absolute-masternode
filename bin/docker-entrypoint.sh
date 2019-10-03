#!/bin/bash
set -x

USER=absolute
chown -R ${USER} /usr/local/bin/absolute*
chmod 777 "$@"
exec gosu ${USER} "$@"