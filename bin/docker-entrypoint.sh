#!/bin/bash

# generate host keys if not present
key_gen() {
    file="/opt/sshd/ssh_host_${1}_key"
    [ ! -f $file ] && echo "Generating ${file}..." && ssh-keygen -t $1 -N '' -f $file -q
}
mkdir /opt/sshd 2>/dev/null
key_gen rsa
key_gen ecdsa
key_gen ed25519

# Check if the authorized_keys file has been mounted. If not exit.
oid=$(stat -c "%u" /root/.ssh/authorized_keys 2>/dev/null)
if [ -f /authorized_keys ]; then
    cp /authorized_keys /root/.ssh/authorized_keys
else
    echo "You should provide a authorized_keys files and mount it to /authorized_keys"
    exit 0
fi

# If nooone is logged in during 5 seconds, the container is stopped
connection-watcher.sh ${CONNECTION_TIMEOUT:-5} &

# do not detach (-D), write debug logs to standard error instead of the system log (-e) and passthrough other arguments
echo "Starting SSH server. The server will be automatically closed after ${CONNECTION_TIMEOUT:-5} seconds without a connected user"
/usr/sbin/sshd -D -e $@
