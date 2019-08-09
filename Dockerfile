ARG postgres_version=11.4

FROM postgres:$postgres_version

ARG oracle_fdw_version=2_1_0
ARG instantclient_version=19_3

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    libaio1 \
    libaio-dev \
    build-essential \
    make \
    unzip \
    postgresql-server-dev-all \
    postgresql-common

COPY sdk\ /tmp

RUN unzip "/tmp/*.zip" -d /tmp

ENV ORACLE_HOME /tmp/instantclient_${instantclient_version}
ENV LD_LIBRARY_PATH /tmp/instantclient_${instantclient_version}

RUN cd /tmp/oracle_fdw-ORACLE_FDW_${oracle_fdw_version} && make && make install

USER postgres

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
