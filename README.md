# Nomad Quickstart

Server container for Hashicorp Nomad with lots of out-of-the box configuration already done:

* persistent data directory 
* mTLS (although not production suitable)
* ACL bootstrapped

This is aimed at being a good toy / experimentation setup but using the 'real' feature set

## Server
Running the root docker container gives you a single-server Nomad setup. e.g. when run like so:

```
docker run -d -P nomad       
```

* 4646 and 4647 will be mapped to ephemeral ports on your localhost
* On first start, the server **auto-generates certificates**. To get the keys view the top of  `docker logs nomad` 
* ACL bootstrapping is performed on first start too. To get the bootstrap key view the tail of the log briefly after startup
* The mTLS configuration, ACL configuration and data are persisted to a volume

By default the server does not `verify_https_client` - this is so you can test out the web UI more easily

## Client

_The client is provided purely for local experimentation since a dockerized nomad client is not particularly useful in the real world._

Once you have the keys from the server, put their values in to the relevant `*.pem` files in the client/ directory and build the container

To get a useful client running against your dockerized server, run the client container like so (obviously dropping rm or adding -d etc. if you want it to persist):

`docker run --rm --network host --privileged nomad_client`

* Host networking is used so that `localhost` resolves - this is **required** for mTLS since the common name of the server needs to be seen to be valid.
    * You can obviously link the client to the server in other ways, but this setup is intended to be extremely simple to bring up and down

* Privileged mode is required because nomad uses `ulimit` to control resource constraints


