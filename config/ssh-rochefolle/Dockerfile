FROM alpine:latest

LABEL maintainer="Cédric Rochefolle <19742131+jscoobyced@users.noreply.github.com>"
LABEL description="Creates and run an SSH server on default port 22."

ARG SSH_PUB_KEY
RUN apk add --update --no-cache openssh mysql-client

RUN adduser -h /home/jscoobyced -D jscoobyced
RUN echo "jscoobyced:$(date +%s | sha256sum | base64 | head -c 32 ; echo -n)" | chpasswd
RUN mkdir /home/jscoobyced/.ssh && chmod 700 /home/jscoobyced/.ssh
RUN echo "$SSH_PUB_KEY" > /home/jscoobyced/.ssh/authorized_keys && \
    chmod 600 /home/jscoobyced/.ssh/authorized_keys
RUN mkdir /home/jscoobyced/bin
COPY mariadb-backup.sh /home/jscoobyced/bin
RUN chmod u+x /home/jscoobyced/bin/mariadb-backup.sh
RUN chown -Rf jscoobyced:jscoobyced /home/jscoobyced/

COPY entrypoint.sh /
RUN chmod u+x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]