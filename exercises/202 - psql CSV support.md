# CSV support

`psql` supports a [`\copy`
command](https://www.postgresql.org/docs/11/app-psql.html#APP-PSQL-META-COMMANDS-COPY)
which can write out a CSV for you, or read a CSV into a table.

    \copy (select * from se_user) to '/tmp/foo.csv' csv

    create table from_csv_se_user as select * from se_user limit 0;
    \copy from_csv_se_user from '/tmp/foo.csv' csv header


# Exercises

1. Produce a CSV showing posts which have been marked as duplicates
   (`post_link.link_type = 'Duplicate'`) of other posts.  Include the body
   (which is HTML) of the post and the duplicate.  Open it in a spreadsheet to
   verify that CSV quoting is happening properly.
2. Re-import your CSV and verify that it matches the results of your original
   query.
