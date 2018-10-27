#!/bin/bash

# only 'postgres' linux user can run sql commands in POSTGRESQL. 
# We have set 'postgres' user as super user by setting POSTGRES_USER variable in the docker file. 
# Superuser password set in the POSTGRES_PASSWORD environment variable

psql -d postgres -U postgres -c "create extension bottledwater;"
psql -d postgres -U postgres -c "create table test (id serial primary key, value text);"
psql -d postgres -U postgres -c "create table echo (id serial primary key, value text);"
psql -d postgres -U postgres -c "create table sleep (id serial primary key, value text);"
psql -d postgres -U postgres -c "create table play (id serial primary key, value text);"


now="$(date)"
echo "Record insertion start date and time: $now"

# during start up insert 25000 records in a table named 'test' for simulation purpose. 1000 rows in each batch
# 'test' table has two columns: 'id' and 'value' where id uniquely identifies an entity (primary key)
# id automatically incremented at the time of each insertion

# Insert in the test table
for batchinsert in {1..25}
do
  echo "PROCESSING BATCH $batchinsert"
  mycommand="insert into test (value) values('Test hello world for new batch');"
  
 
  for i in {2..1000}
  do
    temp1=$(($batchinsert-1))
    temp2=$(($temp1*1000))
    count=$(($temp2+$i))
    msg="Test hello world $count"
    echo $msg
    mycommand+="insert into test (value) values('$msg');"
  done
  
  echo $mycommand
  psql -d postgres -U postgres -c "$mycommand"
done

# Insert in the echo table
for batchinsert in {1..25}
do
  echo "PROCESSING BATCH $batchinsert"
  mycommand="insert into echo (value) values('Echo hello world for new batch');"
  
 
  for i in {2..1000}
  do
    temp1=$(($batchinsert-1))
    temp2=$(($temp1*1000))
    count=$(($temp2+$i))
    msg="Echo hello world $count"
    echo $msg
    mycommand+="insert into echo (value) values('$msg');"
  done
  
  echo $mycommand
  psql -d postgres -U postgres -c "$mycommand"
done


# Insert records in the sleep table
for batchinsert in {1..25}
do
  echo "PROCESSING BATCH $batchinsert"
  mycommand="insert into sleep (value) values('Sleep hello world for new batch');"
  
 
  for i in {2..1000}
  do
    temp1=$(($batchinsert-1))
    temp2=$(($temp1*1000))
    count=$(($temp2+$i))
    msg="Sleep hello world $count"
    echo $msg
    mycommand+="insert into sleep (value) values('$msg');"
  done
  
  echo $mycommand
  psql -d postgres -U postgres -c "$mycommand"
done


# Insert records in the play table
for batchinsert in {1..25}
do
  echo "PROCESSING BATCH $batchinsert"
  mycommand="insert into play (value) values('Play hello world for new batch');"
  
 
  for i in {2..1000}
  do
    temp1=$(($batchinsert-1))
    temp2=$(($temp1*1000))
    count=$(($temp2+$i))
    msg="Play hello world $count"
    echo $msg
    mycommand+="insert into play (value) values('$msg');"
  done
  
  echo $mycommand
  psql -d postgres -U postgres -c "$mycommand"
done




# sleep for 60 seconds and then perform update operation on a single entity
#sleep 30

# Now update the same entity 20 times and see which specific consumer process it and in which order
#for count in {1..20}
#do
   #msg="Modified hello world $count"
   #mycommand="update test set value='$msg' where id=5;"
   #echo $mycommand
   #psql -d postgres -U postgres -c "$mycommand"

   #sleep 3
#done

now="$(date)"
echo "Record insertion end date and time: $now"
