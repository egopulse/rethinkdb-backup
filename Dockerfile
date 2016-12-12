FROM python:2-alpine

RUN pip install rethinkdb
RUN apk add --update --no-cache ruby jq gpgme p7zip && gem install -N ejson

ADD entry.sh /app/entry.sh
ADD script.sh /app/script.sh
ADD password.template /app/password.template
RUN chmod +x /app/entry.sh 
RUN chmod +x /app/script.sh

ENV DB_NAME=test
ENV HOST=rethink
ENV PORT=28015

VOLUME /data/dumped

# One of EVERY_MINUTE, EVERY_15_MINS, EVERY_HOUR, EVERY_DAY
ENV FREQ=EVERY_HOUR
ENV MAX_BACKUP=10
RUN touch /log

CMD /app/entry.sh
