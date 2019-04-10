# Window functions

Window functions are an exceptionally powerful but also complex more recent
addition to the SQL standard.  Postgres has arguably more complete support for
them than any other database.

A simple but often useful example is `rank()`:

    -- For each user, list posts from highest to lowest favorite_count.
      select owner_se_user_id,
             post_id,
             rank() over (partition by owner_se_user_id order by favorite_count) as rank
        from post
    order by owner_se_user_id,
             post_id,
             rank() over (partition by owner_se_user_id order by favorite_count) desc;

Slightly more complex:

    -- How does each post's favorite_count compare to the average
    -- favorite_count for that user?
    select owner_se_user_id as se_user_id,
           post_id,
           favorite_count - (avg(favorite_count) over (partition by owner_se_user_id)) as delta
      from post
           where favorite_count is not null;


# Exercises

1. Select every user who's posted a question and the title of their most popular
   (highest `favorite_count`) question(s) (you should return multiple rows where
   a single user's most favorited question is a tie between multiple posts).
   (Note: you will need a subselect here, because you're not allowed to use
   window functions in where clauses.)
