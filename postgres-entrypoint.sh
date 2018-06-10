#!/bin/bash

psql -h postgres -p 5432 -d postgres -U postgres
create extension bottledwater;
create table test (id serial primary key, value text);
insert into test (value) values('hello world!');
