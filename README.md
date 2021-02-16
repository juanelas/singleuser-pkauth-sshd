# singleuser-pkauth-sshd

This is a docker image of an SSH server thought to be used for TCP forwarding with public key authentication only. It is a single account approach (using the root user). The container is automatically closed if there is not a connected user for 5 seconds or the `CONNECTION_TIMEOUT` environment variable.

You need to provide a valid `authorized_keys` file which should be mounted to `/authorized_keys` in the container. You should also forward a port in you host to port 22 in your container.

You can build and run directly with docker or generate a `docker-compose.yaml` file.

## Usage with docker

Build the image with:

```terminal
docker build -t sshd https://github.com/juanelas/singleuser-pkauth-sshd.git
```

Assuming thath the `authorized_keys` is in your current directory, an example run command forwarding port 8022/tcp in your host would be:

```terminal
docker run --name sshd --rm -p 8022:22/tcp -v $(pwd)/authorized_keys:/authorized_keys -e CONNECTION_TIMEOUT=8 sshd
```

## Usage with docker-compose

An example `docker-compose.yaml` listening on port 8022/tcp and with a connection timeout of 8 seconds:

```yaml
version: '3.4'

services:
  sshd:
    build: https://github.com/juanelas/singleuser-pkauth-sshd.git
    image: sshd
    container_name: sshd
    ports:
      - 8022:22/tcp
    volumes:
      - ./authorized_keys:/authorized_keys
    environment:
      CONNECTION_TIMEOUT: 8

```

And just run `docker-compose up`
