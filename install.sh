#!/bin/bash

while getopts d:e: flag
do
    case "${flag}" in
        d) DOMAIN_NAME=${OPTARG};;
        e) EMAIL_ADDRESS=${OPTARG};;
    esac
done

echo  ------------------------------ Update ------------------------------ 

sudo apt-get update

echo  ------------------------------ Installing packages ------------------------------ 

sudo apt-get install -y build-essential git-core nginx curl libssl-dev pkg-config certbot python3-certbot-nginx

echo  ------------------------------ Installing Certbot ------------------------------ 

certbot run -n --nginx --agree-tos -d $DOMAIN_NAME -m $EMAIL_ADDRESS --redirect

echo  ------------------------------ Installing basic nginx proxy ------------------------------ 

sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default

sudo mkdir -p /var/www/$DOMAIN_NAME/public_html
cat > /etc/nginx/sites-available/$DOMAIN_NAME.conf <<EOF
server {
    listen 80;
    server_name $DOMAIN_NAME;
    return 301 https://$DOMAIN_NAME;
}
server {
    listen 443 ssl;
    server_name $DOMAIN_NAME;
    
    ssl_certificate /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/$DOMAIN_NAME.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx

echo  ------------------------------ Installing nodejs and npm ------------------------------ 

curl -sL https://deb.nodesource.com/setup_current.x | sudo -E bash -

sudo apt-get install -y nodejs

echo  ------------------------------ Installing pm2 ------------------------------ 
npm install pm2 -g

cat > /var/www/$DOMAIN_NAME/public_html/app.js <<EOF
let http = require('http');

http.createServer(function(req, res) {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('APP is ready!');
}).listen(5000, 'localhost');
EOF

cd /
cd /var/www/$DOMAIN_NAME/public_html/

echo  ------------------------------ Running the app ------------------------------ 
sudo pm2 start app.js
