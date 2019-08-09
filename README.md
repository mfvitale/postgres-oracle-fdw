# Intro
All the oracle client library and FDW extention is in the _sdk_ bacause is not possbile to get it through wget from Oracle site.
If you need another version download it from [Oracle site](https://www.oracle.com/database/technologies/instant-client/downloads.html) an put it into sdk folder.
# Build image
```console
docker build -t postgres-ora-fdw:11.4 .
```
## Supported args

| Arg                   | default       |
| -------------         | ------------- |
| postgres_version      | 11.4          |
| oracle_fdw_version    | 2_1_0         |
| instantclient_version | 19_3          |

*Example*
```console
docker build --build-arg postgres_version=10.4 -t postgres-ora-fdw:10.4 .
```
# Run image
docker run -d  --name test-postgres postgres-ora-fdw:11.4

# Create Foreign Data Wrapper
Enter into container
```console
docker exec -it test-postgres bash
```

then

```console
psql
```

then create the extension and the connection to remote DB

```console
CREATE EXTENSION oracle_fdw;
CREATE SERVER oradb FOREIGN DATA WRAPPER oracle_fdw
          OPTIONS (dbserver '//<host>:1521/<database>');
GRANT USAGE ON FOREIGN SERVER oradb TO postgres;
CREATE USER MAPPING FOR postgres SERVER oradb OPTIONS (user 'user', password 'password');
```
then import table (this is like creating a symbolic link to remote database, no data is imported)
```console
IMPORT FOREIGN SCHEMA "<foreignSchemaName>"
    FROM SERVER oradb
    INTO <localSchemaName>;
```

more info on [PostgreSQL docs](https://www.postgresql.org/docs/10/sql-importforeignschema.html).