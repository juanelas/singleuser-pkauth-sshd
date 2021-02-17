#!/bin/bash

# generate host keys if not present
key_gen() {
    file="/opt/sshd/ssh_host_${1}_key"
    [ ! -f $file ] && echo "Generating ${file}..." && ssh-keygen -t $1 -N '' -f $file -q
}
key_gen rsa
key_gen ecdsa
key_gen ed25519

# Check if the authorized_keys file has been mounted. If not exit.
if [ -f /authorized_keys ]; then
    cp /authorized_keys /home/me/.ssh/authorized_keys
    chown me:root /home/me/.ssh/authorized_keys
else
    echo "You should provide an authorized_keys file and mount it to /authorized_keys"
    exit 0
fi

# Prepare SSH welcome msg
MSG=$(cat /ssh_hello.txt 2> /dev/null)
if [ ! -z "$MSG" ]; then
    MSG=${MSG/SSH_HELLO_MSG/${SSH_HELLO_MSG}}
else
    MSG=${SSH_HELLO_MSG:-"Connection succesful"}
fi
echo $MSG > /ssh_hello_msg

# If nooone is logged in during 5 seconds, the container is stopped
connection-watcher.sh ${CONNECTION_TIMEOUT:-5} &

# do not detach (-D), write debug logs to standard error instead of the system log (-e) and passthrough other arguments
echo "Starting SSH server. The server will be automatically closed after ${CONNECTION_TIMEOUT:-5} seconds without a connected user. The only user allowed to connect is 'me' ;-)"
/usr/sbin/sshd -D -e $@
