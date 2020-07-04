## Master Config
- Create user first
```
CREATE USER repl
WITH REPLICATION
ENCRYPTED PASSWORD 'passwordlulz';
```

- Allow repl user connect
```
host replication repl 10.3.48.56/32 md5
```

- Create archive folder:
```
mkdir -p /data/postgresql/archivedir && chown -R postgres: /data/postgresql/archivedir
```

-- Config in master:
```
data_directory = '/data/postgresql/main'                # use data in another directory
hba_file = '/etc/postgresql/12/main/pg_hba.conf'        # host-based authentication file
ident_file = '/etc/postgresql/12/main/pg_ident.conf'    # ident configuration file
external_pid_file = '/var/run/postgresql/12-main.pid'                   # write an extra PID file
listen_addresses = '*'          # what IP address(es) to listen on;
port = 5432                             # (change requires restart)
max_connections = 100                   # (change requires restart)
unix_socket_directories = '/var/run/postgresql' # comma-separated list of directories
ssl = on
ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'
shared_buffers = 1536MB                 # min 128kB
work_mem = 3932kB                               # min 64kB
maintenance_work_mem = 384MB            # min 1MB
dynamic_shared_memory_type = posix      # the default is the first option
effective_io_concurrency = 200          # 1-1000; 0 disables prefetching
wal_level = hot_standby                 # minimal, replica, or logical
wal_buffers = 16MB                      # min 32kB, -1 sets based on shared_buffers
max_wal_size = 4GB
min_wal_size = 1GB
checkpoint_completion_target = 0.9      # checkpoint target duration, 0.0 - 1.0
archive_mode = on               # enables archiving; off, on, or always
archive_command = 'test ! -f /data/postgresql/archivedir/%f && cp %p /data/postgresql/archivedir/%f'            # command to use to archive a logfile segment
max_wal_senders = 3             # max number of walsender processes
random_page_cost = 1.1                  # same scale as above
effective_cache_size = 4GB
default_statistics_target = 100 # range 1-10000
log_line_prefix = '%m [%p] %q%u@%d '            # special values:
log_timezone = 'Asia/Ho_Chi_Minh'
cluster_name = '12/main'                        # added to process titles if nonempty
stats_temp_directory = '/var/run/postgresql/12-main.pg_stat_tmp'
datestyle = 'iso, mdy'
timezone = 'Asia/Ho_Chi_Minh'
lc_messages = 'en_US'                   # locale for system error message
                                        # strings
lc_monetary = 'en_US'                   # locale for monetary formatting
lc_numeric = 'en_US'                    # locale for number formatting
lc_time = 'en_US'                               # locale for time formatting
default_text_search_config = 'pg_catalog.english'
include_dir = 'conf.d'                  # include files ending in '.conf' from
```

But the only thing required for config repl is:
```
listen_addresses= '*'
wal_level = hot_standby
archive_mode= on
archive_command = 'test ! -f /data/postgresql/archivedir/%f && cp %p /data/postgresql/archivedir/%f'            # command to use to archive a logfile segment
max_wal_senders=3
```
## Slave config
- Stop the postgresql
```
service postgresql stop
```
- Rename data folder ( Rename the main in the postgresql directory to something else since the backup won’t replace the existing files in the same folder. )

```
mv /data/postgresql/main /data/postgresql/main_old
```

```
sudo -u postgres pg_basebackup -h 10.3.48.54 -D /data/postgresql/main -U repl -v -P -R
```

Then enter password you used to create repl user

- Then start postgresql


## Check and validate the replication
### From master
- Enter pg shell:
```
select * from pg_stat_replication
```

Example output: 
```
-[ RECORD 1 ]----+------------------------------
pid              | 21733
usesysid         | 17750
usename          | repl
application_name | 12/main
client_addr      | 10.3.48.56
client_hostname  | 
client_port      | 59108
backend_start    | 2020-07-01 16:34:47.426402+07
backend_xmin     | 
state            | streaming
sent_lsn         | 0/8000060
write_lsn        | 0/8000060
flush_lsn        | 0/8000060
replay_lsn       | 0/8000060
write_lag        | 
flush_lag        | 
replay_lag       | 
sync_priority    | 0
sync_state       | async
reply_time       | 2020-07-01 16:35:57.624957+07
```

Slave is : 10.3.48.56
Quit pgshell. And start check process

```
root@sys-test-48-54:/data/postgresql# ps -eaf | grep sender
postgres 21733  6907  0 16:34 ?        00:00:00 postgres: 12/main: walsender repl 10.3.48.56(59108) streaming 0/8000060
root     21980 31473  0 16:35 pts/1    00:00:00 grep --color=auto sender
```

### From slave. Check
```
root@sys-test-48-56:/data/postgresql# ps -ef  | grep postgres
postgres  8023     1  0 16:34 ?        00:00:00 /usr/lib/postgresql/12/bin/postgres -D /data/postgresql/main -c config_file=/etc/postgresql/12/main/postgresql.conf
postgres  8024  8023  0 16:34 ?        00:00:00 postgres: 12/main: startup   recovering 000000010000000000000008
postgres  8035  8023  0 16:34 ?        00:00:00 postgres: 12/main: checkpointer   
postgres  8036  8023  0 16:34 ?        00:00:00 postgres: 12/main: background writer   
postgres  8037  8023  0 16:34 ?        00:00:00 postgres: 12/main: stats collector   
postgres  8038  8023  0 16:34 ?        00:00:00 postgres: 12/main: walreceiver   streaming 0/8000060
root      8480 22229  0 16:35 pts/1    00:00:00 grep --color=auto postgres
```

