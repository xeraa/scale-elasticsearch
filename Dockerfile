ARG ELASTIC_VERSION
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_VERSION}

# This is an ugly workaround to create a backup folder with the right permissions
# If you just create it through the bind mount it would be owned by root,
# which isn't writeable by the Elasticsearch process
RUN mkdir /usr/share/elasticsearch/backup/ && chown elasticsearch:elasticsearch /usr/share/elasticsearch/backup/
