FROM ubuntu:24.04

ARG QUORUM_PORT
ARG P2P_PORT

RUN apt update

RUN apt install -y curl adduser screen gettext unzip jq

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -f awscliv2.zip

RUN curl -so /etc/apt/trusted.gpg.d/oxen.gpg https://deb.oxen.io/pub.gpg

RUN echo "deb https://deb.oxen.io noble main" | tee /etc/apt/sources.list.d/oxen.list

RUN apt update

RUN apt install -y oxen-service-node

COPY etc/oxen/oxen.conf /etc/oxen/oxen_template.conf
COPY etc/loki/lokinet-router.ini /etc/loki/lokinet-router.ini

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["oxend", "--non-interactive", "--config-file=/etc/oxen/oxen.conf"]