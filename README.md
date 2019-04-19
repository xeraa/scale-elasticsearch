# Scale Your Elasticsearch Cluster

Demo code for the [Scale Your Elasticsearch Cluster](https://speakerdeck.com/xeraa/scale-your-elasticsearch-cluster) talk.

**The settings used are for a short lived demo such as a rollover at 5MB. Do not use those for any development or production environment.**


## Flow

Start with a `docker-compose up` and explain the different parts while it is initializing.


### Frozen Index

```bash
PUT frozen
{
  "settings": {
    "index.routing.allocation.include.size": "cold"
  }
}

POST frozen/_doc
{
  "name": "Philipp"
}
POST frozen/_doc
{
  "name": "Nicolas"
}

GET frozen/_search

POST frozen/_forcemerge?max_num_segments=1

POST frozen/_freeze

GET frozen/_search

GET frozen/_search?ignore_throttled=false

GET _cat/indices/frozen?v&h=health,status,index,pri,rep,docs.count,store.size

GET _cat/thread_pool/search_throttled?v&h=node_name,name,active,rejected,queue,completed&s=node_name

GET frozen/_search?ignore_throttled=false&pre_filter_shard_size=1

POST frozen/_doc
{
  "name": "Abdon"
}

GET frozen/_settings?flat_settings=true

POST frozen/_unfreeze

POST frozen/_doc
{
  "name": "Abdon"
}

GET frozen/_search


# Import Kibana sample data (here the ecommerce one)
# Show the dashboard before and after freezing (and fix the setting in Kibana)
POST kibana_sample_data_ecommerce/_freeze
```


### Index Lifecycle Management

Explain how `node.attr.size` is tying the architecture together. Show both *setup/templace_metricbeat.json* and *setup/ilm.json*, explain what is going on, and show the results in Index Management. Also load the ILM configuration in the Kibana UI.


### Rollup

Show the underlying *setup/rollup.json* and how you would build it in the Kibana UI. Add the index pattern for it, show the underlying documents in Discover and build a visualization on the Docker network traffic (if there are a couple of documents at least).


## Todo

* Wait for https://github.com/elastic/beats/pull/11671 to be released to simplify the setup.sh
* Integrate Frozen Indices better into ILM
