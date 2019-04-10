# The basics

Umm, Postgres is a database server, so it executes SQL.  You know some SQL,
right?


# SQL syntax differences from MS SQL Server

### Limit

Postgres uses eg `select ... limit 10;` instead of `select top 10 ...;`.

(Though you can now do it the SQL standard way if you _really_ want: `select
... fetch first 10 rows only;`.)


### `join using`

Postgres supports a simplified join syntax where the left and right hand side
use the same column names for the joined columns:

    select *
      from se_user
           join comment using (se_user_id);


### String concatenation

Postgres follows the SQL standard here (as is often the case) and uses `||` for
string concatenation.  Unlike SQL Server, it doesn't allow `+` for this.


### DDL

In Postgres, there is no `nvarchar` type, and there is no particularly good
reason ever to use the `varchar` type.  If you have a column that stores text,
declare its type as `text`.

There are two timestamp types in Postgres, `timestamp without timezone`
(`timestamp`) and `timestamp with timezone` (`timestamptz`).  You almost always
want `timestamptz` – don't use `timestamp` unless you've read through the docs
in enough detail that you understand the difference (it's not what you think
from the names) and can explain why `timestamptz` would be wrong for your use
case.

Typically for surrogate primary keys, most Postgres users use the `serial` or
`bigserial` types, which automatically give you a sequence.  As of version 10,
Postgres has support for declaring a column as eg `int generated always as
identity`. This form is now preferred.


# Exercises

These are all doable with a single SQL query (without needing sub-selects).

1. How many users have a `gold` badge?
2. What are the display names of the users with more than 10 `gold` badges?
3. My copy of the data dump includes answers that are apparently posted years
   before the question they answer – does yours?
4. Excluding questions that are answered before they're asked, what is the
   question and answer text for the question that was first answered in the
   least amount of time?
5. Same exercise as above, but only considering accepted answers.
