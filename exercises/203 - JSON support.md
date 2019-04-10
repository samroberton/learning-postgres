# JSON

Postgres has two JSON datatypes: `json` and `jsonb`.  All the functions that
operate on JSON come in a `json` and a `jsonb` variant.  You pretty much always
want `jsonb`.

You can produce JSON using `to_jsonb`, and you can pretty-print it, too:

    select jsonb_pretty(to_jsonb(u))
      from se_user u
     limit 2;

There are [a variety of operators for operating on
JSON](https://www.postgresql.org/docs/11/functions-json.html), too.  This is
especially useful when you have a `jsonb` column that you want to query.

    create table my_json_user (
        username text primary key,
        stuff jsonb
    );

    insert into my_json_user (username, stuff)
         values ('alice',   '{"city":"Adelaide"}' ::jsonb),
                ('bob',     '{"city":"Brisbane"}'),
                ('charlie', '{"city":"Canberra"}');

    select username
      from my_json_user
     where stuff->>'city' = 'Brisbane';


# Exercises

1. The `se_user` table has columns like `se_user_id` and `about_me`, but let's
   assume we have a JS front-end that's going to be much more comfortable with
   "userId" and "about" as JSON keys.  Write a `select` query that retrieves a
   JSON payload with just these two keys, as `userId` and `about`, for any given
   display name.  (Note: you'll need a subselect for this, in the form of
   `select to_jsonb(u) from (select ...) u`.)
