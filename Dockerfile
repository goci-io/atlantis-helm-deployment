FROM runatlantis/atlantis:v0.11.1

ADD https://github.com/cloudposse/tfenv/releases/download/0.4.0/tfenv_linux_amd64 /usr/local/bin/tfenv
RUN chmod +x /usr/local/bin/tfenv

COPY config /opt/atlantis/

ENTRYPOINT [ "atlantis" ]
CMD [ "server" ]
