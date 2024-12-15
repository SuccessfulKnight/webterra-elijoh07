#!/bin/bash

# Variables
DB_NAME="example_db"         # Database name
DB_USER="postgres"           # Database user
DB_PASSWORD="postgres"       # Password for the postgres user

# Update the system and install PostgreSQL
echo "Updating system and installing PostgreSQL..."
sudo apt-get update -y
sudo apt-get install -y postgresql

# Start PostgreSQL and enable it on boot
echo "Starting and enabling PostgreSQL service..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Set up the database and table
echo "Configuring PostgreSQL: Creating database '$DB_NAME' and table..."
sudo -u postgres psql <<EOF
CREATE DATABASE $DB_NAME;
\c $DB_NAME
CREATE TABLE example_table (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  description TEXT
);
INSERT INTO example_table (name, description) VALUES
  ('Item 1', 'This is the first item'),
  ('Item 2', 'This is the second item'),
  ('Item 3', 'This is the third item');
ALTER USER $DB_USER PASSWORD '$DB_PASSWORD';
EOF

# Configure PostgreSQL for external access
echo "Configuring PostgreSQL for external access..."
sudo bash -c "echo \"host all all 0.0.0.0/0 md5\" >> /etc/postgresql/*/main/pg_hba.conf"
sudo bash -c "echo \"listen_addresses='*'\" >> /etc/postgresql/*/main/postgresql.conf"

# Restart PostgreSQL to apply changes
echo "Restarting PostgreSQL..."
sudo systemctl restart postgresql

echo "Database setup completed successfully. Ready to accept connections."
