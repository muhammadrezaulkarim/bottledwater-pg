cmake_minimum_required(VERSION 3.6)
project(bottledwater)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

find_package(PostgreSQL REQUIRED)
include_directories(${PostgreSQL_INCLUDE_DIRS})
message(STATUS "PostgreSQL include directories: ${PostgreSQL_INCLUDE_DIRS}\n")

find_package(CURL REQUIRED)
include_directories(${CURL_INCLUDE_DIRS})
message(STATUS "CURL include directories: ${CURL_INCLUDE_DIRS}")
message(STATUS "CURL libraries: ${CURL_LIBRARIES}\n")

find_package(KafkaC REQUIRED)
include_directories(${KAFKAC_INCLUDE_DIRS})
message(STATUS "KafkaC include directories: ${KAFKAC_INCLUDE_DIRS}")
message(STATUS "KafkaC libraries: ${KAFKAC_LIBRARIES}\n")

find_package(AvroC REQUIRED)
include_directories(${AVROC_INCLUDE_DIRS})
message(STATUS "AvroC include directories: ${AVROC_INCLUDE_DIRS}")
message(STATUS "AvroC libraries: ${AVROC_LIBRARIES}\n")

find_package(Jansson REQUIRED)
include_directories(${JANSSON_INCLUDE_DIRS})
message(STATUS "Jansson include directories: ${JANSSON_INCLUDE_DIRS}")
message(STATUS "Jansson libraries: ${JANSSON_LIBRARIES}\n")

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
        ${EXT_HEADER_FILES}
        ${CLIENT_HEADER_FILES}
        ${CLIENT_SOURCE_FILES}
        ${KAFKA_HEADER_FILES}
        ${KAFKA_SOURCE_FILES}
        )
target_include_directories(bottledwater PUBLIC
        ./client
        ./ext)
target_link_libraries(bottledwater PRIVATE
        ${CURL_LIBRARIES}
        ${KAFKAC_LIBRARIES}
        ${AVROC_LIBRARIES}
        ${JANSSON_LIBRARIES})

add_library(bottledwater-ext
        ${CLIENT_HEADER_FILES}
        ${CLIENT_SOURCE_FILES}
        ${EXT_HEADER_FILES}
        ${EXT_SOURCE_FILES}
        )
