#!/bin/bash
exec > >(tee /var/log/user-data.log) 2>&1
set -ex

export HOME=/root
export COMPOSER_HOME=/root/.composer

# Install system dependencies
dnf update -y
dnf install -y \
    php \
    php-cli \
    php-fpm \
    php-mbstring \
    php-xml \
    php-bcmath \
    php-pdo \
    php-mysqlnd \
    php-pgsql \
    nginx \
    git \
    unzip \
    wget \
    ruby \
    postgresql15

# Install Composer
cd /tmp
EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    echo "ERROR: Invalid composer checksum"
    rm composer-setup.php
    exit 1
fi
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

# Install CodeDeploy agent
cd /home/ec2-user
wget https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install -O install
chmod +x ./install
./install auto

# Configure PHP-FPM user
sed -i 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf

# Configure nginx
cat > /etc/nginx/conf.d/laravel.conf <<'NGINXCONF'
server {
    listen 80;
    server_name _;
    root /var/www/laravel/public;

    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/run/php-fpm/www.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
NGINXCONF

# Remove default config to prevent conflicts
rm -f /etc/nginx/conf.d/default.conf

# Enable & start services
systemctl enable php-fpm nginx codedeploy-agent
systemctl start php-fpm nginx codedeploy-agent
