CORE="hupi"
BASEURL="http://localhost:8983/solr"
DOCKERNAME="solr"

echo Removing ${CORE} core
# When I ran this, it gave me the API call: docker exec -it ${DOCKERNAME} bin/solr delete -c ${CORE}
curl "${BASEURL}/admin/cores?action=UNLOAD&core=${CORE}&deleteIndex=true&deleteDataDir=true&deleteInstanceDir=true"

echo Creating ${CORE} core
docker exec -it ${DOCKERNAME} bin/solr create_core -c ${CORE}

echo Make everything searchable
curl -XPOST -H 'Content-type:application/json' \
     --data-binary '{"add-copy-field" : {"source":"*","dest":"_text_"}}' \
     "${BASEURL}/${CORE}/schema"

echo Crawling a site
docker exec -it ${DOCKERNAME} bin/post -c ${CORE} -commit yes -out yes http://hupi.org/ -recursive 1
