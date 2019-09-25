#!/usr/bin/env python
#
#  Load taxlots data from a database into Solr, using the REST API.
#

# first let's just read a JSON text file
import json
jsonfile = 'taxlots_owner.json'

# iterate the data, and feed it to Solr.

with open(jsonfile) as f:
    d = json.load(f)
    print(d)
    exit(0)
