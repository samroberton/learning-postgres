# Getting started

The `docker` directory contains enough to get you started with a PostgreSQL 11
database bootstrapped with the latest `archive.org`-hosted data dump of
`dba.stackexchange.com`.

    docker build --tag learning-postgres docker
    docker run --publish 5432:5432 learning-postgres

(If you already have a Postgres on your system running on port 5432, then you'll
want to change that `--publish` flag to eg `5433:5432`, to avoid a port
conflict.)

If you already have `psql` installed on your local machine, then in another
terminal you can now:

    psql --host localhost --port 5432 --user postgres

(Change `5432` for whatever port you gave to `docker run --publish` above.)

If you don't have `psql` installed locally, then you can use another instance of
the same Docker image (again in another terminal):

    docker run --interactive --tty learning-postgres psql --host <your-ip> --port 5432 --user postgres

(Similarly, change `5432` for whatever port you used above.)


# Then what?

Once you have the docker container running, jump into the [exercises](exercises) directory
and pick some exercises that sound interesting to work through.
