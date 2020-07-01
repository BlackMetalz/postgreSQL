# pg_hba.conf
- Example:
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
# Database administrative login by Unix domain socket
local   all             postgres                                peer
# "local" is for Unix domain socket connections only
local   all             all                                     peer
# IPv4 local connections:
host    all             username             10.5.0.1/32            md5
# Allow replication connections from localhost, by a user with the
# replication privilege.
host    replication     all             10.5.0.1/32            md5
```

- Reload after modifed:
```
psql -U postgres
postgres=> SELECT pg_reload_conf();
```
