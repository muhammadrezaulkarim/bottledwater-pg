#!/bin/bash

sudo -u postgres psql -d postgres -U postgres -c "create extension bottledwater;"
sudo -u postgres psql -d postgres -U postgres -c "create table test (id serial primary key, value text);"
sudo -u postgres psql -d postgres -U postgres -c "insert into test (value) values('hello world!');"
