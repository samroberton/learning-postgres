# Arrays

The relational model per Codd and Date and co suggests that tables should be
able to contain colums whose values are themselves tables.  SQL suggests 'not so
much, thanks'.

However, Postgres allows values to be declared as arrays of a particular type
(even allowing for multi-dimensional arrays).

You can have a table with an array column – the `post.tags` column, for example.
But more often, this is useful because you can aggregate values into an array
with `array_agg`.  For example, you might want to know what badges each user
has, but without having to return one row per badge per user:

      select u.se_user_id,
             u.display_name,
             array_agg(b.name) as badge_names
        from se_user u
             join badge b using (se_user_id)
    group by u.se_user_id,
             u.display_name;

You can also go the other way: given an array of values in a single row, explode
that out into multiple rows, one per array value:

    select post_id,
           unnest(tags) as tag
      from post;


# Exercises

1. For each 'Question' post, display a single row containing (a) the display
   name of the user who posted the question, and (b) a list (array) of the
   display names of all users who answered it.
2. The `tag` table contains a list of tags.  Each row in the `post` table
   identifies an array of tags which are associated with that post.  Is there a
   `tag` row which has no posts with that tag?  Are there any entries missing
   from the `tag` table?  (Hint: you want two separate queries to answer these
   two questions, and you want `select ... except select ...`.)
