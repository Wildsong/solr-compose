CORE="taxlots"
DATAFILE="taxlots_owner.json"
BASEURL="http://localhost:8983/solr"
DOCKERNAME="solr"

echo Removing ${CORE} core
# When I ran this command, it gave me the API call to use for this script:
# docker exec -it ${DOCKERNAME} bin/solr delete -c ${CORE}
curl "${BASEURL}/admin/cores?action=UNLOAD&core=${CORE}&deleteIndex=true&deleteDataDir=true&deleteInstanceDir=true"

echo Creating ${CORE} core
docker exec -it ${DOCKERNAME} bin/solr create_core -c ${CORE}

# We do this in the first line of the JSON here"
#echo "Customize fields as needed for this data."
#curl -XPOST -H 'Content-type:application/json' \
#   --data-binary '{"add-field" : {"name":"name","type":"text_general","multiValued":"false","stored":"true"}}' \
#   "${BASEURL}/${CORE}/schema"

echo Make everything searchable
curl -XPOST -H 'Content-type:application/json' \
     --data-binary '{"add-copy-field" : {"source":"*","dest":"_text_"}}' \
     "${BASEURL}/${CORE}/schema"

echo Loading data from $DATAFILE into $CORE.
curl -XPOST -H 'Content-type:application/json' \
     -d @${DATAFILE} \
     "${BASEURL}/${CORE}/update?commit=true"
