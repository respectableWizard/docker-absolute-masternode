#!/bin/bash
set -x

USER=absolute
chown -R ${USER} /usr/local/bin/absolute*
exec gosu ${USER} "$@"