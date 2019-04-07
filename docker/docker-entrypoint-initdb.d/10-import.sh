#! /usr/bin/env bash

for FILE in /tmp/source-data/Users-*.xml; do
    psql -c "select import_users_file('${FILE}');"
done

for FILE in /tmp/source-data/Posts-*.xml; do
    psql -c "select import_posts_file('${FILE}');"
done

for FILE in /tmp/source-data/Comments-*.xml; do
    psql -c "select import_comments_file('${FILE}');"
done

for FILE in /tmp/source-data/Badges-*.xml; do
    psql -c "select import_badges_file('${FILE}');"
done

for FILE in /tmp/source-data/Tags-*.xml; do
    psql -c "select import_tags_file('${FILE}');"
done

for FILE in /tmp/source-data/Votes-*.xml; do
    psql -c "select import_votes_file('${FILE}');"
done

for FILE in /tmp/source-data/PostLinks-*.xml; do
    psql -c "select import_post_links_file('${FILE}');"
done

for FILE in /tmp/source-data/PostHistory-*.xml; do
    psql -c "select import_post_history_file('${FILE}');"
done
