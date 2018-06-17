#!/bin/bash

# only 'postgres' linux user can run sql commands in POSTGRESQL. 
# We have set 'postgres' user as super user by setting POSTGRES_USER variable in the docker file. 
# Superuser password set in the POSTGRES_PASSWORD environment variable

psql -d postgres -U postgres -c "create extension bottledwater;"
psql -d postgres -U postgres -c "create table test (id serial primary key, value text);"
#psql -d postgres -U postgres -c "insert into test (value) values('hello world!');"

# Waiting until postgres is up
now="$(date)"
echo "Record insertion start date and time: $now"

# during start up insert 13000 records in a table for simulation purpose 
for i in {1..13000}
do
  temp1=HelloWorld 
  msg='${temp1} ${i}'
  echo $msg
  mycommand="insert into test (value) values('$msg');"
  exec "psql -d postgres -U postgres -c" "$mycommand"
done

now="$(date)"
echo "Record insertion end date and time: $now"
