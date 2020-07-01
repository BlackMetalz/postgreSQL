# General: 
- List all DB:
```
\l
```
- Switch DB / Use DB:
```
\c db_name
```
- List all Tables:
```
\dt
```
- Show all users:
```
\du
```
- Create table command:
```
create table wtf (id integer primary key, name varchar);
```
- Clone table from exist table
```
CREATE TABLE new_table AS 
SELECT
*
FROM
    existing_table;
```

1. Select 
# Source: https://www.postgresqltutorial.com/postgresql-select/
just like mysql :v 

2. Using SELECT statement with expressions example
```
SELECT 
   first_name || ' ' || last_name AS full_name,
   email
FROM 
   customer;
```

