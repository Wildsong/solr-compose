--- psql -q -h localhost -U gis_owner gis_data -f taxlots_owner.sql -o taxlots_owner.json
---
--- Remember to make this acceptable to solr post, you will need to make it a list
--- by wrapping it with [].
---
---
SELECT concat(json_build_object(
       'account_id', tl.account_id,
       'centroid', ST_AsLatLonText(ST_Transform(ST_Centroid(tl.geom),4326), 'D.DDDD '),
       'owner', tl.owner_line,
       'owner_1', tl.owner_ll_1,
       'owner_2', tl.owner_ll_2,
---       'in_care_of', tl.in_care_of,
       'street', tl.street_add,
---       'unit_numbe', tl.unit_numbe,
---       'optional_a', tl.optional_a,
---       'po_box', tl.po_box,
       'city', tl.city,
       'state', tl.state,
       'zip_code', tl.zip_code
), ',')
FROM clatsop.taxlots AS tl

