#!/bin/sh

[ -z "$PUBLIC_KEY" ] && echo "Need to set PUBLIC_KEY" && exit 1;

cat /app/password.template | sed s/PASSWORD_PLACE_HOLDER/$PUBLIC_KEY/ > /app/password

export EVERYDAY='0 0 * * *'
export EVERY_MINUTE='* * * * *'
export EVERY_HOUR='0 * * * *'

echo "$(printenv "$FREQ")" /app/script.sh > /app/cronspec

cat /app/cronspec
crontab /app/cronspec

crond &

tail -f /log
