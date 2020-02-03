FROM runatlantis/atlantis:v0.11.1

LABEL org.label-schema.name="atlantis" \
      org.label-schema.description="Extended runatlantis/atlantis image to fulfil goci needs" \
      org.label-schema.vcs-url="https://github.com/goci-io/atlantis-helm-deployment" \
      org.label-schema.url="https://goci.io/" \
      org.label-schema.vendor="goci.io" \
      org.label-schema.version="0.1.0" \
      org.label-schema.schema-version="1.0"

ADD https://github.com/cloudposse/tfenv/releases/download/0.4.0/tfenv_linux_amd64 /usr/local/bin/tfenv
RUN chmod +x /usr/local/bin/tfenv

COPY config /opt/atlantis/

ENTRYPOINT [ "atlantis" ]
CMD [ "server" ]
