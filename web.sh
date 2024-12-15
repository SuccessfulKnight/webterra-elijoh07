#!/bin/bash

# Update system and install required packages
echo "Updating system and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y python3 python3-pip nginx libpq-dev

# Install Python modules
echo "Installing Python modules..."
sudo pip3 install flask psycopg2-binary

# Set up Flask application
echo "Setting up Flask application..."
sudo mkdir -p /opt/web_app
sudo bash -c 'cat > /opt/web_app/app.py' <<EOF
from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

# Database configuration
DB_HOST = "${1}"  # Load Balancer IP passed dynamically
DB_NAME = "example_db"
DB_USER = "postgres"
DB_PASS = "postgres"

@app.route("/")
def get_data():
    try:
        # Connect to the database
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS
        )
        cur = conn.cursor()
        cur.execute("SELECT * FROM example_table;")
        rows = cur.fetchall()
        data = [{"id": row[0], "name": row[1], "description": row[2]} for row in rows]
        cur.close()
        conn.close()
        return jsonify({"data": data})
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

# Configure Flask as a systemd service
echo "Configuring Flask service..."
sudo bash -c 'cat > /etc/systemd/system/flask_app.service' <<EOF
[Unit]
Description=Flask Application
After=network.target

[Service]
User=root
WorkingDirectory=/opt/web_app
ExecStart=/usr/bin/python3 /opt/web_app/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Restart services
echo "Restarting services..."
sudo systemctl daemon-reload
sudo systemctl enable flask_app
sudo systemctl start flask_app

# Configure Nginx as a reverse proxy
echo "Configuring Nginx..."
sudo bash -c 'cat > /etc/nginx/sites-available/default' <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo systemctl restart nginx

echo "Web server setup completed. Access the server's public IP in your browser."
