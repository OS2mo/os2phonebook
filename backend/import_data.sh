#!/usr/bin/env bash
set -ex

BASEDIR=$(cd $(dirname $0); pwd)

PYTHON=$BASEDIR/venv/bin/python
PROGRAM=$BASEDIR/import/do_import.py
VAR_DIR=$BASEDIR/var
DATA_DIR=$VAR_DIR/data

source $BASEDIR/config.sh

# Do the deed
export IMPORT_LOG_FILE API_TOKEN MO_URL MO_ORG_ROOT EXCLUDE

$PYTHON $PROGRAM -d "$DATA_DIR" -v DEBUG

# Bail out if there's an error
status=$?

if [ $status -ne 0 ]
then
    echo "Import from MO failed. See $IMPORT_LOG_FILE for details."
    exit 1
fi

# Now transfer to SOLR


# First, clean index for existing data.
echo "<delete><query>*:*</query></delete>" | $SOLR_POST -c departments -d
echo "<delete><query>*:*</query></delete>" | $SOLR_POST -c employees -d

# Reindex
$SOLR_POST -c departments $DATA_DIR/departments
$SOLR_POST -c employees $DATA_DIR/employees

# Clean up after yourself.
rm -rf $DATA_DIR
