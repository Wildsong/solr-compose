#!/usr/bin/env python
#
#  Load taxlots data from a database into Solr, using the REST API.
#

from sqlalchemy import create_engine, MetaData, Table

engine = create_engine("postgresql://gis_owner:jackrabbit@localhost/gis_data", echo=True)

metadata = MetaData()

taxlots = Table('taxlots',  metadata, autoload=True, autoload_with=engine, schema='clatsop')
conn = engine.connect()
