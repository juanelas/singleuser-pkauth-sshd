FROM debian:buster

RUN apt-get update && apt-get install -y openssh-server && rm -rf /var/lib/apt/lists/* && rm /etc/ssh/ssh_host* && mkdir /run/sshd && mkdir /root/.ssh

COPY ./config/sshd_config /etc/ssh/sshd_config
COPY ./bin/* /usr/local/bin/

VOLUME [ "/opt/sshd" ]

ENTRYPOINT [ "docker-entrypoint.sh" ]
