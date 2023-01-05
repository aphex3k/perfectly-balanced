FROM rebalancelnd/rebalance-lnd:latest

COPY perfectlybalanced.sh /perfectly-balanced/perfectlybalanced.sh

RUN chmod a+x /perfectly-balanced/perfectlybalanced.sh \
    && mkdir -p /root/.lnd

RUN apk add --update --no-cache bash bc

VOLUME [ "/root/.lnd", "/tmp" ]
WORKDIR /perfectly-balanced

ENV REBALANCE_LND_FILEPATH=/rebalance-lnd/rebalance.py

ENTRYPOINT ["/perfectly-balanced/perfectlybalanced.sh"]