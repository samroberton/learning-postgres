# `returning` clauses

In Postgres, inserts, updates and deletes can return details of the rows they
affected.

    -- People with names starting with spaces don't deserve badges.
    delete from badge
          where se_user_id in ( select se_user_id
                                  from se_user
                                 where display_name like ' %'
                              )
      returning se_user_id,
                name,
                class;


# Exercises

1. Let's assume that allowing display names to start with a space is a bug.  In
   a single SQL statement, update all the users whose names start with spaces so
   that they no longer do, and return the creation_date of the earliest post
   those users ever made, so we can try to narrow down when this bug was
   introduced.
