#!/usr/bin/env bash
set -e

# We assume the first argument to the script is the LB IP
LB_IP="$1"

# Hard-coded Postgres credentials (adjust if needed)
DB_USER="postgres"
DB_PASS="postgres"
DB_NAME="example_db"
DB_TABLE="example_table"

WEBAPP_DIR="/var/www/mywebapp"
APP_USER="www-data"
SERVER_NAME="_"  # Use _ or your domain/IP. If you have a domain, put it here.
                 # If not, use _ to listen on any hostname.

# Update and upgrade
apt-get update && apt-get upgrade -y

# Install required packages
apt-get install -y python3 python3-venv python3-pip nginx postgresql-client libpq-dev build-essential

# Create application directory
mkdir -p "$WEBAPP_DIR"
cd "$WEBAPP_DIR"

# Create a virtual environment and activate it
python3 -m venv venv
source venv/bin/activate

# Install Gunicorn, Flask, and psycopg2 for PostgreSQL
pip install gunicorn flask psycopg2

# Create a simple Flask application
cat > "$WEBAPP_DIR/app.py" <<EOF
import os
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

DB_HOST = os.environ.get('DB_HOST', '$LB_IP')
DB_USER = os.environ.get('DB_USER', '$DB_USER')
DB_PASS = os.environ.get('DB_PASS', '$DB_PASS')
DB_NAME = os.environ.get('DB_NAME', '$DB_NAME')
DB_TABLE = os.environ.get('DB_TABLE', '$DB_TABLE')

@app.route('/')
def index():
    conn = psycopg2.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASS,
        dbname=DB_NAME
    )
    
    cursor = conn.cursor()
    query = f"SELECT * FROM {DB_TABLE} LIMIT 3;"
    cursor.execute(query)
    rows = cursor.fetchall()

    data = []
    for row in rows:
        # Assuming table columns: id, name, value
        # row[0]: id, row[1]: name, row[2]: value
        data.append({
            "id": row[0],
            "name": row[1],
            "value": row[2]
        })

    cursor.close()
    conn.close()
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# Deactivate the virtual environment
deactivate

# Create a Gunicorn systemd service file
cat > /etc/systemd/system/gunicorn.service <<EOF
[Unit]
Description=Gunicorn instance to serve mywebapp
After=network.target

[Service]
User=$APP_USER
Group=www-data
WorkingDirectory=$WEBAPP_DIR
Environment="PATH=$WEBAPP_DIR/venv/bin"
Environment="DB_HOST=$LB_IP"
Environment="DB_USER=$DB_USER"
Environment="DB_PASS=$DB_PASS"
Environment="DB_NAME=$DB_NAME"
Environment="DB_TABLE=$DB_TABLE"
ExecStart=$WEBAPP_DIR/venv/bin/gunicorn --workers 3 --bind 127.0.0.1:8000 app:app

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start Gunicorn service
systemctl daemon-reload
systemctl start gunicorn
systemctl enable gunicorn

# Configure Nginx
rm -f /etc/nginx/sites-enabled/default

cat > /etc/nginx/sites-available/mywebapp <<EOF
server {
    listen 80;
    server_name $SERVER_NAME;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

ln -s /etc/nginx/sites-available/mywebapp /etc/nginx/sites-enabled/mywebapp

# Test and reload Nginx
nginx -t && systemctl reload nginx

echo "Setup complete. Your web application should be accessible at http://$SERVER_NAME/ (or the server's IP)."
