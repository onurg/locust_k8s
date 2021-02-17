FROM python:3.7-alpine3.9

COPY docker-entrypoint.sh /

RUN apk --no-cache add --virtual=.build-dep build-base \
    && apk --no-cache add zeromq-dev \
    && pip install --no-cache-dir locustio==0.11.0 \
    && apk del .build-dep \
    && chmod +x /docker-entrypoint.sh

WORKDIR /locust

EXPOSE 8089 5557 5558

COPY locustfile.py .

ENTRYPOINT ["/docker-entrypoint.sh"]
