# Install go here: https://www.postgresql.org/download/linux/debian/
```
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt-get update
apt-get install postgresql-12
```

1. Login and connect as default user. No pass needed
```
sudo -u postgres psql
```

- Select version
```
select version();
```

- Change password:
```
alter user postgres password 'passgohere';
```

after that we can login from normal user shell
```
psql -U postgres -h localhost -p 5432
```
it will promts the password. Enter the password then done.

2. Setup pgadmin ( web ui management for pgsql )
- Pgadmin: Install it first for web only since we install pgadmin in server
```
#
# Setup the repository
#

# Install the public key for the repository (if not done previously):
curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add

# Create the repository configuration file:
sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'

# Install for web mode only: 
apt install pgadmin4-web -y

# Configure the webserver, if you installed pgadmin4-web:
/usr/pgadmin4/bin/setup-web.sh
During setup it will ask serveral information.

After done. Access it with http://127.0.0.1/pgadmin4
email and pass you entered during installation
```

3. Load sample database for Pgsql
# Go here: https://www.postgresqltutorial.com/load-postgresql-sample-database/
After get the datasample. Restore it
```
pg_restore -U postgres -d dvdrental dvdrental.tar -h localhost -p 5432
```

After restore we can take a look in pgadmin. Remember to add a server with your information. Then you will see 2 databases:
One is postgres, second is what we just create and restore data to there ( dvdrental )
