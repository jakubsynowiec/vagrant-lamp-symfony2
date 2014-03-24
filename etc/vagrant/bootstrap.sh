#!/bin/sh

# Check if was bootstrapped
test -f /etc/bootstrapped && exit

# Set timezone
echo "Setting timezone to Europe/Warsaw"
echo "------------------------"
echo "Europe/Warsaw" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# Change and re-generate locale
echo "Setting locale to pl_PL.UTF-8"
echo "-----------------------"
update-locale LANG=pl_PL.UTF-8

# Add APT repos
echo "Adding APT repos"
echo "------------------------"
echo "deb http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu precise main" | sudo tee -a /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C

# Update package list
echo "Updating package list"
echo "------------------------"
apt-get -qq update

# Install base packages
echo "Installing base packages"
echo "------------------------"
apt-get -qq -y install python-software-properties build-essential git-core curl acl

# Install MySQL
echo "Installing MySQL"
echo "------------------------"
echo mysql-server mysql-server/root_password select "vagrant" | debconf-set-selections
echo mysql-server mysql-server/root_password_again select "vagrant" | debconf-set-selections
apt-get -qq -y install mysql-server

# Configure MySQL
cat << EOF | sudo tee -a /etc/mysql/conf.d/default_engine.cnf
[mysqld]
default-storage-engine = MyISAM
EOF

mysql -u root -p"vagrant" -e ";DROP DATABASE test;DROP USER ''@'localhost';CREATE DATABASE vagrant;GRANT ALL ON vagrant.* TO vagrant@localhost IDENTIFIED BY 'vagrant';"
service mysql restart

# Install Apache2 and PHP 5.4
echo "Installing PHP 5.4 and Apache2"
echo "------------------------"
apt-get -qq -y install php5 php5-cli php5-mysql php5-curl php5-intl php-apc apache2 libapache2-mod-php5

# Configure PHP
sed -i "s/max_execution_time = 30/max_execution_time = 60/" /etc/php5/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 20M/" /etc/php5/apache2/php.ini
sed -i "s/post_max_size = 16M/post_max_size = 20M/" /etc/php5/apache2/php.ini
sed -i "s/short_open_tag = On/short_open_tag = Off/" /etc/php5/apache2/php.ini
sed -i "s/;date.timezone =/date.timezone = Europe\/Warsaw/" /etc/php5/apache2/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 256M/" /etc/php5/apache2/php.ini
sed -i "s/_errors = Off/_errors = On/" /etc/php5/apache2/php.ini

# Configure Apache
echo "Configuring Apache2"
echo "------------------------"
service apache2 stop
a2dissite 000-default
rm -rf /var/www
ln -fs /vagrant/symfony /var/www
cp /vagrant/etc/apache/symfony.localhost /etc/apache2/sites-available/symfony.localhost
sed -i 's/www-data/vagrant/g' /etc/apache2/envvars
a2ensite symfony.localhost
sudo a2enmod rewrite
rm -rf /var/lock/apache2
service apache2 start

# Install Composer
echo "Installing Composer"
echo "------------------------"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Cleanup
apt-get -y autoremove
apt-get clean
unset HISTFILE
[ -f /root/.bash_history ] && rm /root/.bash_history
[ -f /home/vagrant/.bash_history ] && rm /home/vagrant/.bash_history
find /var/log -type f | while read f; do echo -ne '' > $f; done

echo "You've been provisioned"
date > /etc/bootstrapped