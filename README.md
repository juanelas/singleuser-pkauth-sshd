# singleuser-pkauth-sshd

This is a docker image of an SSH server thought to be used for TCP forwarding with public key authentication only. It is a single account approach (using user `me`). The container is automatically closed if there is not a connected user for 5 seconds or the `CONNECTION_TIMEOUT` environment variable.

You need to provide a valid `authorized_keys` file which should be mounted to `/authorized_keys` in the container.

The SSH welcome can be customized pass a text file to `/ssh_hello.txt` as a volume or use the `SSH_HELLO_MSG` environment variable. If both are present, the file acts as a template and the string `SSH_HELLO_MSG` will be replaced by the contents of the `SSH_HELLO_MSG` environment variable.

You can build and run directly with docker or generate a `docker-compose.yaml` file.

## Usage with docker

Build the image with:

```terminal
docker build -t sshd https://github.com/juanelas/singleuser-pkauth-sshd.git
```

An example run command could be:

```terminal
docker run --name sshd --rm -p 8022:22/tcp -v $(pwd)/authorized_keys:/authorized_keys -e CONNECTION_TIMEOUT=8 -v sshd-keys:/opt/sshd sshd
```

The command it is assuming that:

- you are redirecting your host machine port 8022/tcp to the sshd container
- you have an `authorized_keys` file in your current directory
- the connection timeout for the container to be destroyed (if there is not any active connection) is 8 seconds
- the sshd server keys persist in a named volume called `sshd-keys`

## Usage with docker-compose

The above example using a `docker-compose.yaml` file would be like follows, although now the connection timeout is 8 seconds, we are providing a ssh hello message template in `ssh_hello.txt` and replacing the string `SSH_HELLO_MSG` in the template with the contents of the environment variable `SSH_HELLO_MSG`.

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
      - ./ssh_hello.txt:/ssh_hello.txt
      - sshd-keys:/opt/sshd
    environment:
      CONNECTION_TIMEOUT: 8
      SSH_HELLO_MSG: 'Yuhuuu'

```
