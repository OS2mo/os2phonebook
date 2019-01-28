#/usr/bin/env bash
# NOTE: This script will install and setup SOLR for use in the phone
# book.

cd $(dirname $0)


    #Get SOLR
    wget http://dk.mirrors.quenda.co/apache/lucene/solr/7.6.0/solr-7.6.0.tgz

    # Verify SOLR download
    if shasum -s -c docs/solr.sha1 
    then 
        echo 'SOLR download OK'
    else 
        echo 'SOLR download failed!'
        exit 1
    fi

    tar xzf solr-7.6.0.tgz solr-7.6.0/bin/install_solr_service.sh --strip-components=2
    sudo bash ./install_solr_service.sh solr-7.6.0.tgz

    sudo -u solr /opt/solr/bin/solr create -c departments -s 2 -rf 2
    sudo -u solr /opt/solr/bin/solr create -c employees -s 2 -rf 2

    # Create schema for departments
    
   curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"document", "type":"text_general", "multiValued":false, "stored":true, indexed: false}}' http://localhost:8983/solr/departments/schema
   curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"name", "type":"text_general", "multiValued":false, "stored":false}}' http://localhost:8983/solr/departments/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"uuid", "type":"text_general", "multiValued":false, "stored":false}}' http://localhost:8983/solr/departments/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"parent", "type":"text_general", "multiValued":false, "stored":false}}' http://localhost:8983/solr/departments/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"locations", "type":"text_general", "multiValued":true, "stored":false}}' http://localhost:8983/solr/departments/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"employees", "type":"text_general", "multiValued":true, "stored":false}}' http://localhost:8983/solr/departments/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"departments", "type":"text_general", "multiValued":true, "stored":false}}' http://localhost:8983/solr/departments/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"associated", "type":"text_general", "multiValued":true, "stored":false}}' http://localhost:8983/solr/departments/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"managers", "type":"text_general", "multiValued":true, "stored":false}}' http://localhost:8983/solr/departments/schema

  # Create schema for employees
   curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"document", "type":"text_general", "multiValued":false, "stored":true, indexed: false}}' http://localhost:8983/solr/employees/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"name", "type":"text_general", "multiValued":false, "stored":false}}' http://localhost:8983/solr/employees/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"uuid", "type":"text_general", "multiValued":false, "stored":false}}' http://localhost:8983/solr/employees/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"locations", "type":"text_general", "multiValued":true, "stored":false}}' http://localhost:8983/solr/employees/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"departments", "type":"text_general", "multiValued":true, "stored":false}}' http://localhost:8983/solr/employees/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"associated", "type":"text_general", "multiValued":true, "stored":false}}' http://localhost:8983/solr/employees/schema
    curl -X POST -H 'Content-type:application/json' --data-binary '{"add-field": {"name":"managing", "type":"text_general", "multiValued":true, "stored":false}}' http://localhost:8983/solr/employees/schema

    echo "SOLR installed, SOlR started."



