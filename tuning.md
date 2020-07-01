# Credit: https://www.percona.com/blog/2018/08/31/tuning-postgresql-database-parameters-to-optimize-performance/
# Another: https://pgtune.leopard.in.ua/
# Another: https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server
- shared_buffers: The shared_buffers configuration parameter determines how much memory is dedicated to PostgreSQL to use for caching data
mostly in this case 25% amount of RAM your server have.

- An example for Server 3c_6g:
```
# DB Version: 12
# OS Type: linux
# DB Type: mixed
# Total Memory (RAM): 6 GB
# Data Storage: ssd

max_connections = 100
shared_buffers = 1536MB
effective_cache_size = 4608MB
maintenance_work_mem = 384MB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
work_mem = 3932kB
min_wal_size = 1GB
max_wal_size = 4GB
```

