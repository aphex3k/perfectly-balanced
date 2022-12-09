FROM alpine:3.17 AS build-env

RUN apk add --update --no-cache git

RUN git clone --depth 1 https://github.com/cuaritas/perfectly-balanced /perfectly-balanced
RUN chmod a+x /perfectly-balanced/perfectlybalanced.sh \
    && mkdir /root/.lnd

FROM rebalancelnd/rebalance-lnd:latest

RUN apk add --update --no-cache bash bc

COPY --from=build-env /perfectly-balanced/ /perfectly-balanced/

VOLUME [ "/root/.lnd" ]
WORKDIR /perfectly-balanced

ENTRYPOINT ["/perfectly-balanced/perfectlybalanced.sh"]
