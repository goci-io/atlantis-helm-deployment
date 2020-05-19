FROM runatlantis/atlantis:v0.12.0

LABEL org.label-schema.name="atlantis" \
      org.label-schema.description="Extended runatlantis/atlantis image to fulfil goci needs" \
      org.label-schema.vcs-url="https://github.com/goci-io/atlantis-helm-deployment" \
      org.label-schema.url="https://goci.io/" \
      org.label-schema.vendor="goci.io" \
      org.label-schema.version="0.2.0" \
      org.label-schema.schema-version="1.0"

RUN curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip \
  && unzip /tmp/awscliv2.zip \
  && ./aws/install \
  && rm -rf ./aws

ADD https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

ENTRYPOINT [ "atlantis" ]
CMD [ "server" ]
