#!/bin/bash

# only 'postgres' linux user can run sql commands in POSTGRESQL. 
# We have set 'postgres' user as super user by setting POSTGRES_USER variable in the docker file. 
# Superuser password set in the POSTGRES_PASSWORD environment variable

psql -d postgres -U postgres -c "create extension bottledwater;"
psql -d postgres -U postgres -c "create table test (id serial primary key, value text);"
psql -d postgres -U postgres -c "insert into test (value) values('hello world!');"

