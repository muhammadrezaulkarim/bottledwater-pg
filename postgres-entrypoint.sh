#!/bin/bash

# only 'postgres' linux user can run sql commands in POSTGRESQL. 
# We have set 'postgres' user as super user by setting POSTGRES_USER variable in the docker file. 
# Superuser password set in the POSTGRES_PASSWORD environment variable

psql -d postgres -U postgres -c "create extension bottledwater;"
psql -d postgres -U postgres -c "create table test (id serial primary key, value text);"
#psql -d postgres -U postgres -c "insert into test (value) values('hello world!');"

now="$(date)"
echo "Record insertion start date and time: $now"

# during start up insert 10000 records in a table for simulation purpose. 1000 in each batch

for batchinsert in {1..1}
do
  echo "PROCESSING BATCH $batchinsert"
  mycommand="insert into test (value) values('hello world 1');"
  
  for i in {2..25000}
  do
    msg="hello world $i"
    echo $msg
    mycommand+="insert into test (value) values('$msg');"
  done
  
  echo $mycommand
  psql -d postgres -U postgres -c "$mycommand"
done

now="$(date)"
echo "Record insertion end date and time: $now"
