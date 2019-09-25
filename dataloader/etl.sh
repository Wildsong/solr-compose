#!/bin/bash

JSONFILE="taxlots_owner.json"

# Extract taxlots from database in JSON format
# -t removes headers and footers
psql -q -h localhost -U gis_owner -t gis_data -f taxlots_owner.sql -o tpg.json

# wrap with [] to make it a list
echo "["       >  $JSONFILE

# This fake starting line has text in the zip_code field to trick schemaless post into doing the write thing.
echo ' {"account_id" : 9999998, "centroid" : "46.0 -124.0 ", "owner" : "null", "owner_1" : "null", "owner_2" : "null", "street" : "null", "city" : "null", "state" : "null", "zip_code" : "null"},' >> $JSONFILE

cat < tpg.json >> $JSONFILE

# This fake ending line has no comma at the end to create legit json output.
echo ' {"account_id" : 9999999, "centroid" : "46.0 -124.0 ", "owner" : "null", "owner_1" : "null", "owner_2" : "null", "street" : "null", "city" : "null", "state" : "null", "zip_code" : "null"}'  >> $JSONFILE

# wrap with [] to make it a list
echo "]"       >> $JSONFILE
rm tpg.json

# feed it to Solr
docker exec -it solr bin/post -c taxlots $JSONFILE

