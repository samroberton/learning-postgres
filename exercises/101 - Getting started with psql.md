# Getting started with `psql`

One big Postgres difference for developers coming from eg SQL Server is the lack
of a SQL Server Management Studio equivalent.  Instead, Postgres comes with
`psql`, a command-line client.  What is this, the 1970s?!

If you want a GUI tool, I recommend JetBrains'
[DataGrip](https://www.jetbrains.com/datagrip/).

But even if you decide you're going to use DataGrip day-to-day, you should at
least get familiar with `psql`.


## Basic `psql` usage

Connect to the DB with something like this:

    psql --host localhost --port 5432 --user postgres

Now you're at what you might as well think of as a database REPL, with a prompt.
Mine looks like this (because of my `.psqlrc`, see below):

    [localhost] postgres@postgres =#

Type some SQL, get a result:

    [localhost] postgres@postgres =# select 'hello, world!' as greeting;
       greeting
    ═══════════════
     hello, world!
    (1 row)


SQL statements are terminated by semi-colons.  You can write a statement that
spans multiple lines: if you hit enter without having terminated the statement,
you'll get a continuation prompt.

    [localhost] postgres@postgres =# select 'hello, world' as greeting,
    postgres-# '!' as punctuation;
       greeting   │ punctuation
    ══════════════╪═════════════
     hello, world │ !
    (1 row)


## `\?`

`psql` has built-in help.

    [localhost] postgres@postgres =# \?

Have a quick glance over what you can do – the most important commands are under
the "Informational" heading.

Try `\dt` to get a list of tables in the current database.  Try `\d se_user` or
`\d+ se_user` to get more detailed information on the `se_user` table.

`psql` also has tab-completion: `\d <tab><tab>` will show completion candidates.



## `.psqlrc`

`psql` is customisable, most commonly via a `.psqlrc` file in your home
directory.  If you're just starting out, I recommend you copy
[mine](https://github.com/samroberton/dotfiles/blob/master/psql/psqlrc).



## `\i file.sql`

Postgres can run a file as a SQL script using eg `\i query.sql`.  This can be
especially handy if you want to put together a more complex query in an editor.
(There's also an `\e` command, which launches your editor for you, with the
query.)


# Exercises

1. How many tables are there in the database?
2. Which table consumes the most disk space?
3. The database has been populated (on Docker container startup) by a series of
   calls to SQL functions (stored procs) named like `import_*_file`. Get `psql`
   to show you the source code for one of them.
4. There are several enum data types used in this database.  What are they?
   What values do they have?
