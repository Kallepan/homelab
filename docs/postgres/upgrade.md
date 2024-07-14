# Upgrade PostgreSQL

## Description

In PostgreSQL, you can't upgrade from one major version to another. You have to
dump the database, remove the old container, create a new one with the new
version, and restore the database.

There is also pg_upgrade, but this is easier for the containerized version.

## Steps

1. Stop the PostgreSQL container:

    ```bash
    docker-compose stop postgres
    ```

2. Create a dump of the database:

    ```bash
    sudo docker exec -it ${CONTAINER_ID} pg_dumpall -U postgres > /path/to/dump.sql
    cp /path/to/dump.sql /path/to/in/container/dump.sql
    ```

3. update the version in the `docker-compose.yml` file:

4. Remove the old container data volume:

    ```bash
    docker volume rm postgres_data # or the path to the volume
    rm -rf /path/to/postgres_data
    ```

5. Start the PostgreSQL container:

    ```bash
    docker-compose up -d postgres
    ```

6. Restore the database:

    ```bash
    docker exec -it ${CONTAINER_ID} sh
    psql -U postgres < /path/to/dump.sql
    ```

7. Profit!
