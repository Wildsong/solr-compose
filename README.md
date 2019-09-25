=solr-compose

This is a docker-compose configuration for Solr.

I added the JTS package to support spatial data operations.

Official documentation: https://hub.docker.com/_/solr

== Start everything up 

The compose file will start everything.
```
  docker-compose up
```

I use a docker that proxies my web services and provides them with SSL
certificates. It's part of my GeoServer project.  If you are running
something similar this should work. 

  https://solr.wildsong.biz/solr

or if not, maybe this is good enough for you?

  http://localhost:8983/

== Create a core

docker exec -it --user=solr solr bin/solr create_core -c taxlots

== Add some data to it

=== ETL 

Earlier, I had a version of PostGIS with taxlots in it and extracted it into JSON for indexing.

Convert a shapefile to geojson format:
```
ogr2ogr -f 'GeoJSON' taxlots.json taxlots.shp
```

Upload and index it via curl:
```
curl -XPOST -H 'Content-type: application/json' --data @taxlots.json 'http://localhost:8983/solr/taxlots/update/json/docs'

=== Shapefile to CSV

I have also used a shapefile distributed by Clatsop County as a way to generate a CSV file,
as CSV is suggested in the Geoserver docs.

```
# Polygons
ogr2ogr -f CSV -dialect sqlite -sql "select ST_AsText(geometry), OBJECTID1 as id,TAXLOTKEY,OWNER_LINE,OWNER_LL_1,OWNER_LL_2,SITUS_ADDR,'taxlots' as layer FROM taxlots_accounts" -lco geometry=AS_WKT -s_srs "EPSG:2913" -t_srs "EPSG:4326" taxlots_accounts.csv taxlots_accounts.shp

# Remove the columns line, which mess everything up
tail -n +2 taxlots_accounts.csv >t.csv

# You must maintain the field order but rename them here whatever way you wish

curl "http://localhost:8983/solr/taxlots/update/csv?commit=true&separator=%2c&fieldnames=geo,id,taxlotkey_s,owner_s,owner_1_s,owner_2,situs,layer_s" -H "Content-type:text/csv; charset=utf-8" --data-binary @t.csv
```
