#!/usr/bin/env bash
set -e

# Update system and install PostgreSQL
sudo apt-get update -y
sudo apt-get install -y postgresql

# Start and enable PostgreSQL
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Configure PostgreSQL database and table
sudo -u postgres psql <<EOF
CREATE DATABASE example_db;
\c example_db
CREATE TABLE example_table (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50),
  description TEXT
);

INSERT INTO example_table (name, description) VALUES
  ('Item 1', 'This is the first item'),
  ('Item 2', 'This is the second item'),
  ('Item 3', 'This is the third item');

ALTER USER postgres WITH PASSWORD 'postgres';
EOF

# Allow external access
sudo bash -c "echo \"listen_addresses = '*'\" >> /etc/postgresql/*/main/postgresql.conf"
sudo bash -c "echo \"host all all 0.0.0.0/0 md5\" >> /etc/postgresql/*/main/pg_hba.conf"

# Restart PostgreSQL to apply changes
sudo systemctl restart postgresql
