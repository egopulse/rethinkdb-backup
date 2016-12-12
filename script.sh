#!/bin/sh

password=$(ejson keygen | sed -n '2p')

# Encrypting original password

cd /tmp

rethinkdb-dump -c $HOST:$PORT -e $DB_NAME
cat /app/password | sed s/PLACE_HOLDER/$password/ > t.ejson && ejson encrypt t.ejson
ls -t rethink* | head -n 1 | xargs -I '{}' 7z a -mem=AES256 -tzip -p"$password" -sdel "{}.zip" "{}"
mv t.ejson "pwd.$(ls -t | head -n 1)"

unset password

mv ./* /data/dumped

cd /data/dumped
ls -t rethink* | tail -n "+$(($MAX_BACKUP + 1))" | xargs rm -rf