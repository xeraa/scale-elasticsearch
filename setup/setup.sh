#!/bin/bash -ex

ES_URL=http://elasticsearch-hot:9200

# Wait for Elasticsearch to start up before doing anything.
until curl -s ${ES_URL}/_cat/health -o /dev/null; do
    echo Waiting for Elasticsearch...
    sleep 3
done


# Wait for Kibana to start up before doing anything.
until curl -s http://kibana:5601/ -o /dev/null; do
    echo Waiting for Kibana...
    sleep 3
done

# Load the relevant settings for ILM
curl -s -H 'Content-Type: application/json' -XPUT ${ES_URL}/_cluster/settings -d@/opt/setup/cluster.json
curl -s -H 'Content-Type: application/json' -XPUT ${ES_URL}/_ilm/policy/metricbeat -d@/opt/setup/ilm.json
curl -s -H 'Content-Type: application/json' -XPUT ${ES_URL}/_template/metricbeat-custom -d@/opt/setup/template_metricbeat.json
curl -s -H 'Content-Type: application/json' -XPUT ${ES_URL}/metricbeat-000000 -d@/opt/setup/index.json

# Load the relevant settings for Rollups
curl -s -H 'Content-Type: application/json' -XPUT ${ES_URL}/_template/rollup -d@/opt/setup/template_rollup.json
sleep 5m # Wait until (hopefully) there is Metricbeat data, which is needed to target fields in the rollup
curl -s -H 'Content-Type: application/json' -XPUT ${ES_URL}/_rollup/job/metricbeat -d@/opt/setup/rollup.json
curl -s -H 'Content-Type: application/json' -XPOST ${ES_URL}/_rollup/job/metricbeat/_start
