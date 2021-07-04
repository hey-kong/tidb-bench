#!/bin/bash
set -eu

SCALE="1"
TEMPLATE_DIR="../query_templates"
OUTPUT_DIR="queries"
QUERY_ID=""

function generate_query()
{
    ./dsqgen \
    -DIRECTORY "$TEMPLATE_DIR" \
    -INPUT "$TEMPLATE_DIR/templates.lst" \
    -SCALE $SCALE \
    -OUTPUT_DIR $OUTPUT_DIR \
    -DIALECT netezza \
    -TEMPLATE "query$QUERY_ID.tpl"
    mv "$OUTPUT_DIR/query_0.sql" "$OUTPUT_DIR/query_$QUERY_ID.sql"
}

cte="1 2 4 5 11 14 23 24 30 31 33 39 47 51 54 56 57 58 59 60 64 74 75 77 78 80 81 83 95 97"

cd tools
rm -rf $OUTPUT_DIR
mkdir $OUTPUT_DIR
for i in $cte; do
    QUERY_ID="$i"
    generate_query
done
mv $OUTPUT_DIR ..
cd -
