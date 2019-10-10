#!/bin/bash
set -x

USER=absolute
chown -R ${USER} /usr/local/bin/absolute*
chown -R ${USER} ${HOME}
cron && exec gosu ${USER} "$@"