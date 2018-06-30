#!/bin/bash

# only 'postgres' linux user can run sql commands in POSTGRESQL. 
# We have set 'postgres' user as super user by setting POSTGRES_USER variable in the docker file. 
# Superuser password set in the POSTGRES_PASSWORD environment variable

psql -d postgres -U postgres -c "create extension bottledwater;"
psql -d postgres -U postgres -c "create table test (id serial primary key, value text);"
#psql -d postgres -U postgres -c "insert into test (value) values('hello world!');"

now="$(date)"
echo "Record insertion start date and time: $now"

# during start up insert 25000 records in a table named 'test' for simulation purpose. 1000 rows in each batch
# 'test' table has two columns: 'id' and 'value' where id uniquely identifies an entity (primary key)
# id automatically incremented at the time of each insertion

for batchinsert in {1..25}
do
  echo "PROCESSING BATCH $batchinsert"
  mycommand="insert into test (value) values('hello world for new batch');"
  
 
  for i in {2..1000}
  do
    temp1=$(($batchinsert-1))
    temp2=$(($temp1*1000))
    count=$(($temp2+$i))
    msg="hello world $count"
    echo $msg
    mycommand+="insert into test (value) values('$msg');"
  done
  
  echo $mycommand
  psql -d postgres -U postgres -c "$mycommand"
done

# sleep for 60 seconds and then perform update operation on a single entity
sleep 60

# Now update the same entity 100 times and see which specific consumer process it and in which order
for count in {1..100}
do
   msg="Modified hello world $count"
   mycommand="update test set value='$msg' where id=5;"
   echo $mycommand
   psql -d postgres -U postgres -c "$mycommand"
   # sleep for 20 seconds before you update the same entity again
   sleep 20
done

now="$(date)"
echo "Record insertion end date and time: $now"
