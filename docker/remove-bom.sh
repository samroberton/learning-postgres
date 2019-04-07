#! /usr/bin/env bash

set -o errexit

for FILE in "$@"; do
    if [[ "$(file ${FILE})" == *UTF-8\ Unicode\ \(with\ BOM\)* ]]; then
        TMPFILE=$(mktemp)
        tail -c +4 "${FILE}" > "${TMPFILE}"
        mv "${TMPFILE}" "${FILE}"
    fi
done
