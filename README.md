=solr-compose

This is a docker-compose configuration for Solr

Official documentation: https://hub.docker.com/_/solr

== Start everything up 

The compose file will start everything.
```
  docker-compose up
```

I use a docker that proxies my web services and provides them with SSL
certificates. It's part of my GeoServer project.  If you are running
something similar this should work. 

  https://solr.wildsong.biz

or if not, maybe this is good enough for you?

  http://localhost:8983/

== Create a core

docker exec -it --user=solr solr bin/solr create_core -c taxlots