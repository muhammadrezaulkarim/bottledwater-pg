#!/bin/bash

psql -d postgres -U postgres
create extension bottledwater;
create table test (id serial primary key, value text);
insert into test (value) values('hello world!');
