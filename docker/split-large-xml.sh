#! /usr/bin/env bash

set -o errexit
set -o pipefail

FILE="$2"
CHUNK_SIZE="$1"

NUMBER_OF_LINES=$(wc -l "${FILE}" | cut -f 1 -d ' ')
NUMBER_OF_CHUNKS=$(( ($NUMBER_OF_LINES - 3) / $CHUNK_SIZE ))

START=$(head -n 2 "${FILE}")
END=$(tail -n 1 "${FILE}")

for (( NUM=0; NUM <= NUMBER_OF_CHUNKS ; NUM++ )) ; do
    OUTFILE="${FILE%.*}-$(printf %05d $NUM).${FILE##*.}"
    OFFSET=$(( ( $NUM * $CHUNK_SIZE ) + 3 ))
    echo "${START}" > "${OUTFILE}"
    set +o pipefail # head will not consume all its input, therefore will exit with code 141.
    head -n -1 "${FILE}" | tail -n +$OFFSET | head -n $CHUNK_SIZE >> "${OUTFILE}"
    set -o pipefail
    echo "${END}" >> "${OUTFILE}"
done
