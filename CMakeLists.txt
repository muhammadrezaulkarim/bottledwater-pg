cmake_minimum_required(VERSION 3.6)
project(bottledwater)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(CLIENT_HEADER_FILES
        client/connect.h
        client/protocol_client.h
        client/replication.h
        )

set(CLIENT_SOURCE_FILES
        client/bwtest.c
        client/connect.c
        client/protocol_client.c
        client/replication.c
        )

set(EXT_HEADER_FILES
        ext/error_policy.h
        ext/io_util.h
        ext/oid2avro.h
        ext/protocol.h
        ext/protocol_server.h
        ext/schema_cache.h
        )

set(EXT_SOURCE_FILES
        ext/error_policy.c
        ext/io_util.c
        ext/logdecoder.c
        ext/oid2avro.c
        ext/protocol.c
        ext/protocol_server.c
        ext/schema_cache.c
        ext/snapshot.c
        )

set(KAFKA_HEADER_FILES
        kafka/json.h
        kafka/logger.h
        kafka/registry.h
        kafka/table_mapper.h
        )

set(KAFKA_SOURCE_FILES
        kafka/bottledwater.c
        kafka/json.c
        kafka/logger.c
        kafka/registry.c
        kafka/table_mapper.c
        )

add_executable(bottledwater
        ${CLIENT_HEADER_FILES}
        ${CLIENT_SOURCE_FILES}
        ${KAFKA_HEADER_FILES}
        ${KAFKA_SOURCE_FILES}
        )

add_library(bottledwater-ext
        ${CLIENT_HEADER_FILES}
        ${CLIENT_SOURCE_FILES}
        ${EXT_HEADER_FILES}
        ${EXT_SOURCE_FILES}
        )
