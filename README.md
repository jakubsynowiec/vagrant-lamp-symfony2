Vagrant LAMP for Symfony2
============

Vagrant box for Symfony2 development.

Installation:
-------------

Download and install [VirtualBox](http://www.virtualbox.org/)

Download and install [vagrant](http://vagrantup.com/)

Clone this repository

Go to the repository folder and install Symfony2 under symfony directory

    $ cd [repo]
    $ cd symfony
    $ composer create-project symfony/framework-standard-edition .

Launch the box

    $ cd ..
    $ vagrant up

What's inside:
--------------

* Apache
* MySQL
* PHP 5.4 with intl, apc and curl
* [Composer](http://getcomposer.org/)

Notes
-----

### Apache virtual hosts

`/vagrant/symfony` folder is symlinked as `/var/www` and there is a default vhost configured pointing to `/vagrant/symfony/web`.


### MySQL

MySQL is available from localhost. There is already an empty database named `vagrant`, accessible by user `vagrant` with password `vagrant`.

### Composer

Composer binary is installed globally (to `/usr/local/bin/composer`), so you can simply call `composer` from any directory.