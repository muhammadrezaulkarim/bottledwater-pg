# Builds Bottled Water and its dependencies inside a Docker container.
# The resulting image is quite large, because all the development tools
# are installed into it. However, the build process generates tar'ed
# binaries which you can copy out and apply to a base Postgres image.
#
# The Makefile provides a 'docker' target that automates this process:
#
#   $ make docker
#
# See the Makefile and the other Dockerfiles in this directory for more
# detail on how the build artifacts are used.

FROM postgres:9.5

ENV RDKAFKA_VERSION=0.9.1 \
    RDKAFKA_SHASUM="b9d0dd1de53d9f566312c4dd148a4548b4e9a6c2  /root/librdkafka-0.9.1.tar.gz" \
    AVRO_C_VERSION=1.8.0 \
    AVRO_C_SHASUM="af7757633ccf067b1f140c58161e2cdc2f2f003d  /root/avro-c-1.8.0.tar.gz"


# Create Symbolic link to point to python 3
RUN \
  ln -s /usr/bin/python3 /usr/bin/python 
# python stuff finished

RUN apt-get update && \
    # --force-yes is needed because we may need to downgrade libpq5 to $PG_MAJOR
    # (set by the postgres:9.5 Docker image).  Confusingly the postgres:x.y
    # Docker images have been known to include libpq5 version > x.y, which we
    # may not yet be compatible with, so we can't rely on just specifying the
    # image tag to pin the libpq version.
    apt-get install -y --no-install-recommends --force-yes \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        libcurl4-openssl-dev \
        zlib1g \
        zlib1g-dev \ 
        libjansson-dev \
        libpq5=${PG_MAJOR}\* \
        libpq-dev=${PG_MAJOR}\* \
        pkg-config \
        postgresql-server-dev-${PG_MAJOR}=${PG_MAJOR}\*

# Avro
RUN curl -o /root/avro-c-${AVRO_C_VERSION}.tar.gz -SL http://archive.apache.org/dist/avro/avro-${AVRO_C_VERSION}/c/avro-c-${AVRO_C_VERSION}.tar.gz && \
    echo "${AVRO_C_SHASUM}" | shasum -a 1 -b -c && \
    tar -xzf /root/avro-c-${AVRO_C_VERSION}.tar.gz -C /root && \
    mkdir /root/avro-c-${AVRO_C_VERSION}/build && \
    cd /root/avro-c-${AVRO_C_VERSION}/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_BUILD_TYPE=RelWithDebInfo && \
    make && make test && make install && cd / && \
    tar czf avro.tar.gz usr/local/include/avro usr/local/lib/libavro* usr/local/lib/pkgconfig/avro-c.pc

# librdkafka
RUN curl -o /root/librdkafka-0.9.1.tar.gz -SL https://github.com/edenhill/librdkafka/archive/0.9.1.tar.gz && \
    echo "${RDKAFKA_SHASUM}" | shasum -a 1 -b -c && \
    tar -xzf /root/librdkafka-0.9.1.tar.gz -C /root && \
    cd /root/librdkafka-0.9.1 && ./configure && make && make install && cd / && \
    tar czf librdkafka.tar.gz usr/local/include/librdkafka usr/local/lib/librdkafka*

# Bottled Water
COPY . /root/bottledwater
RUN cd /root/bottledwater && \
    make clean && make && make install && cd / && \
    tar czf bottledwater-ext.tar.gz usr/lib/postgresql/${PG_MAJOR}/lib/bottledwater.so usr/share/postgresql/${PG_MAJOR}/extension/bottledwater* && \
    cp /root/bottledwater/kafka/bottledwater /root/bottledwater/client/bwtest /usr/local/bin && \
    tar czf bottledwater-bin.tar.gz usr/local/bin/bottledwater usr/local/bin/bwtest


# Configurations for BOTTLEDWATER RELAY CLIENT
#configure the bottledwater-docker-wrapper.sh (need to be executed for relay topic to kafka)
COPY bottledwater-docker-wrapper.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/bottledwater-docker-wrapper.sh

RUN cp /usr/local/lib/librdkafka.so.* /usr/lib/x86_64-linux-gnu && \
    cp /usr/local/lib/libavro.so.* /usr/lib/x86_64-linux-gnu

# Configurations for POSTGRES-BOTTLEDWATER EXTENSION
#Entry point for POSTGRES database (extension is created here)
RUN chmod +x /usr/local/bin/postgres-entrypoint.sh
COPY replication-config.sh /docker-entrypoint-initdb.d/replication-config.sh
COPY postgres-entrypoint.sh /docker-entrypoint-initdb.d/postgres-entrypoint.sh

