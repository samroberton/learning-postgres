FROM postgres:11.1 as base
RUN apt-get update && apt-get install postgresql-11-pgtap p7zip-full -y

RUN mkdir /tmp/source-data

ADD https://archive.org/download/stackexchange/dba.stackexchange.com.7z /tmp/source-data/dba.stackexchange.com.7z

ADD ./remove-bom.sh /remove-bom.sh
ADD ./split-large-xml.sh /split-large-xml.sh

RUN cd /tmp/source-data \
       && 7z x dba.stackexchange.com.7z \
       && rm dba.stackexchange.com.7z \
       && /remove-bom.sh *.xml \
       && for FILE in *.xml; do /split-large-xml.sh 2000 "${FILE}"; rm "${FILE}"; done \
       && chown postgres:postgres *.xml


ADD ./docker-entrypoint-initdb.d /docker-entrypoint-initdb.d
