# Query plans

You ask `psql` for a query plan by prepending the query with `explain`:

    explain
     select u.display_name,
            p.body
       from se_user u
            join post p on p.owner_se_user_id = u.se_user_id;

You ask for a query plan _and ask `psql` to run it and tell you the execution
details by prepending the query with `explain analyze`.

In a query plan, Postgres reports a `cost` as a range for each operation.
`cost` is a unitless numeric value, only intended to be compared to other `cost`
estimates – you can't convert it to expected execution time, for example.


# Exercises

Take some queries you've written for other exercises and have a look at their
query plans.

There are currently no indexes in this database, so they query plans will
involve a lot of `Seq Scan`s.  This is not ideal.  Try defining some indexes to
fix this.  I suggest you define the index(es) within a transaction, so that you
can see what the query plan looks like afterwards and just rollback the
transaction if you want not to use that but instead to try different indexes.
