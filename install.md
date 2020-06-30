# Install go here: https://www.postgresql.org/download/linux/debian/
```
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql
```

1. Login and connect as default user. No pass needed
```
sudo -u postgres psql
```

- Select version
```
select version();
```

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
# /usr/lib/postgresql/12/bin/pg_restore -u post ( in progress )

