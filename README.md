# Easy VPS Deploy for Ubuntu 20.04
I created this shell script to help to install programs and packages quickly and easy way.
Tested on DigitalOcean service.

## Include
* Nginx
* GIT
* Certbot for Let's Encrypt SSL
* Node.js & npm - install the latest features versions
* pm2 - package for node.js

## How To Use

```
bash install.sh -d YOURDOMAIN.COM -e YOUREMAIL@ADDRESS.COM
```

## About this shell script
The script install programs and packages and set https certification for your domain.
And it creates a basic node.js program that runs on the port of 5000

## Useful References and Sources

* [Install Nodejs](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-ubuntu-20-04)
* [A good shell script pattern](https://gist.github.com/anatoliychakkaev/744062/6160cecb209eb371bc6d15f73ecc8f39fae7fc52#file-install-nodejs)
* [Nginx Lets Encrypt installer](https://github.com/renjithspace/nginx-lets-encrypt-installer/blob/master/installer.sh)