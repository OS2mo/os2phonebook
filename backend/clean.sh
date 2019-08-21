#/usr/bin/env bash

cd $(dirname $0)
source config.sh

# First, stop SOLR to avoid dangling processes.
if [ -f solr-${SOLR_VERSION}/bin/solr ]
then
    solr-${SOLR_VERSION}/bin/solr stop -all
fi

# Remove everything that's not source.
rm -rf solr-${SOLR_VERSION}/ var/ import/__pycache__/ venv/ build/ coverage.xml
