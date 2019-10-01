Absolute masternode for docker
=============================

Docker image that runs the Airabsolute daemon which can be turned into a masternode with the correct configuration.

Quick Start
-------------

```shell
docker run \
  -d \
  -e PORT=${PORT}\
  -e EXTERNALIP=xx.xx.xx.xx \
  -e MASTERNODEGENKEY=${MASTERNODEGENKEY} \
  -v </some/directory>:/home/absolute \
  --name=absolute \
  respectablewizard/absolute
```

## Advanced configuration ##

``` shell
export PORT=7208
docker run \
  -d \
  -e PORT=${PORT}\
  -e EXTERNALIP=xx.xx.xx.xx \
  -e MASTERNODEGENKEY=${MASTERNODEGENKEY} \
  -v </some/directory>:/home/absolute \
  --name=absolute \
  respectablewizard/absolute
```

You can also change the default RPC port with -e RPCPORT

This will create the folder `.absolute` in `/some/directory` with a bare `absolute.conf`. You might want to edit the `absolute.conf` before running the container because with the bare config file it doesn't do much, it's basically just an empty wallet.

TODO: Enable RPC monitoring on port 7209