#!/bin/sh

echo "Starting Apache HTTP Server..."
echo "Apache HTTP Server version: $(httpd -v)"
echo "PHP version: $(php -v)"
echo "PHP configuration file: $(php --ini | grep 'Loaded Configuration File')"
echo "Composer version: $(composer -V)"
echo "Node.js version: $(node -v)"
echo "NPM version: $(npm -v)"
echo "Yarn version: $(yarn -v)"
echo "PNPM version: $(pnpm -v)"

if [ -n "$TZ" ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

if [ -z "$PWD" ]; then
    PWD=/var/www/html
fi

if [ -n "$HOST_ID" ]; then
    usermod -u $HOST_ID www-data
fi

if [ -n "$HOST_GID" ]; then
    groupmod -g $HOST_GID www-data
fi

if [ "$INI_ENV" = "development" ]; then
    cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
fi

cd $PWD

if [ -f "composer.json" ]; then
    composer install --no-interaction --no-progress --optimize-autoloader
fi

if [ -d "/var/www/html/uploads" ]; then
    chown -R www-data:www-data /var/www/html/uploads
fi

# cd $PWD && printenv > .env # Uncomment if you want to use .env file
/usr/local/bin/httpd-foreground
