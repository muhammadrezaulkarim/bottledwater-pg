#!/usr/bin/env bash

exec "psql -h postgres -p 5432 -d postgres -U postgres"
exec "create extension bottledwater;"
exec "create table test (id serial primary key, value text);"
exec "insert into test (value) values('hello world!');"
