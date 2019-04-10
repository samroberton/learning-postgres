# Common Table Expressions with mutation

Common Table Expressions (CTEs) are the `with` clauses you see in some complex
SQL.

        with prolific_user as (   select owner_se_user_id as se_user_id
                                    from post
                                group by owner_se_user_id
                                  having count(1) > 100
                              )
      select se_user_id as "prolific user se_user_id",
             count(1) as "badge count"
        from badge
             join prolific_user using (se_user_id)
    group by se_user_id
    order by count(1) desc;

Where the SQL in a CTE is a `select`, it's normally possible to rewrite the
query to use a sub-select as well.  (In fact, in Postgres, it's often better to
do that because CTEs are [optimisation
fences](https://blog.2ndquadrant.com/postgresql-ctes-are-optimization-fences/) –
although that's planned to change in Postgres 12.)

However, unlike most databases, Postgres allows the `with` clause to be an
`insert`, `update` or `delete`, as well.  Normally, you'll use this in tandem
with a [`returning` clause](204 - 'returning' clauses.md):

    -- Remove leading spaces from display names and downvote all the
    -- posts of the users who did that.
      with smart_alec as (    update se_user
                                 set display_name = trim(display_name)
                               where display_name like ' %'
                           returning se_user_id
                         )
    insert
      into vote ( post_id,
                  vote_type,
                  se_user_id,
                  creation_date
                )
    select p.post_id,
           'DownMod',
           -1,
           now()
      from post p
           join smart_alec u on p.owner_se_user_id = u.se_user_id;


# Exercises

1. Construct a single SQL statement which inserts a new `post` and updates the
   `last_access_date` of its author.
