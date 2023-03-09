# -------------------------------- Пути к PHP -------------------------------- #
PHPv1 = 7.0
PHPv2 = 7.3
PHP1_CONF = /etc/php/$(PHPv1)/fpm/pool.d/www.conf
PHP2_CONF = /etc/php/$(PHPv2)/fpm/pool.d/www.conf
APACHEPORTS_CONF = /etc/apache2/ports.conf

# ------------------------------ Точки установки ----------------------------- #
# Установка Apache
apache:
	@apt update
	@apt install -y apache2
	@sed -i '/^Listen 80/s/$$/80/g' $(APACHEPORTS_CONF)
	@systemctl start apache2
	@systemctl enable apache2

# Установка пробного сайта
example:
	@cp -r ./www/example.ru /var/www
	@cp -r ./sites-available/* /etc/apache2/sites-available
	@a2ensite example.ru.conf
	@systemctl reload apache2

# Установка PHP разных версий
php:
	@apt-get install software-properties-common -y
	@add-apt-repository -y ppa:ondrej/php
	@apt-get update -y
	@apt-get install php$(PHPv1) php$(PHPv1)-fpm php$(PHPv1)-mysql libapache2-mod-php$(PHPv1) libapache2-mod-fcgid -y
	@apt-get install php$(PHPv2) php$(PHPv2)-fpm php$(PHPv2)-mysql libapache2-mod-php$(PHPv2) -y
	@sed -i '/^;security.limit_extensions/s/;//g' $(PHP1_CONF)
	@sed -i '/^security.limit_extensions/s/$$/ .html .wsgi/g' $(PHP1_CONF)
	@sed -i '/^;listen.allowed_clients/s/;//g' $(PHP1_CONF)
	@sed -i '/^;security.limit_extensions/s/;//g' $(PHP2_CONF)
	@sed -i '/^security.limit_extensions/s/$$/ .html .wsgi/g' $(PHP2_CONF)
	@sed -i '/^;listen.allowed_clients/s/;//g' $(PHP2_CONF)
	@systemctl start php$(PHPv1)-fpm
	@systemctl enable php$(PHPv1)-fpm
	@systemctl start php$(PHPv2)-fpm
	@systemctl enable php$(PHPv2)-fpm
	@a2enmod actions fcgid alias proxy_fcgi
	@systemctl reload apache2

# Установка тестовых сайтов на PHP
php7ru:
	@cp -r ./www/php0.ru /var/www && cp -r ./www/php3.ru /var/www
	@cp -r ./sites-available/* /etc/apache2/sites-available
	@a2ensite php0.ru.conf && a2ensite php3.ru.conf
	@systemctl reload apache2

# Установка mysql
mysql: wp_init.sql
	@apt update -y
	@apt-get install -y mysql-server
	@apt-get install -y mysql-client
	@mysql -uroot -hlocalhost < $<

# Установка wordpress
wordpress:
	@apt update -y
	@apt install -y wordpress php$(PHPv1)-curl php$(PHPv1)-gd php$(PHPv1)-mbstring php$(PHPv1)-xml php$(PHPv1)-xmlrpc php$(PHPv1)-soap php$(PHPv1)-intl php$(PHPv1)-zip
	@apt install -y php$(PHPv2)-curl php$(PHPv2)-gd php$(PHPv2)-mbstring php$(PHPv2)-xml php$(PHPv2)-xmlrpc php$(PHPv2)-soap php$(PHPv2)-intl php$(PHPv2)-zip
	@a2enmod rewrite
	@cp -r ./sites-available/wordpress_init.conf /etc/apache2/sites-available
	@a2ensite wordpress_init.conf
	@systemctl reload apache2

# ------------------------------ Точки удаления ------------------------------ #
# Удаление Apache
del_apache:
	@systemctl stop apache2
	@apt-get remove --purge -y apache2*
	@apt-get remove --purge -y libapache2-mod-*
	@rm -rf /etc/apache2

# Удаление пробного сайта
del_example:
	@a2dissite example.ru.conf
	@rm -f /etc/apache2/sites-available/example.ru.conf
	@rm -rf /var/www/example.ru
	@systemctl reload apache2

# Удаление PHP
del_php:
	@systemctl stop php$(PHPv1)-fpm
	@systemctl stop php$(PHPv2)-fpm
	@apt-get remove --purge php7* -y
	@apt-get remove --purge php-common -y
	@apt-get remove --purge libapache2-mod-fcgid -y

# Удаление тестовых сайтов на PHP
del_php7ru:
	@a2dissite php0.ru.conf && a2dissite php3.ru.conf
	@rm -f /etc/apache2/sites-available/php0.ru.conf
	@rm -f /etc/apache2/sites-available/php3.ru.conf
	@rm -rf /var/www/php0.ru
	@rm -rf /var/www/php3.ru
	@systemctl reload apache2

del_mysql:
	@systemctl stop mysql
	@apt-get remove --purge -y mysql-*
	@rm -rf /var/lib/mysql*
	@rm -rf /etc/mysql/
	@rm -rf /var/log/mysql
	@deluser --remove-home --quiet mysql

del_wordpress:
	@a2dismod rewrite
	@apt-get remove --purge -y php7*-curl php7*-gd php7*-mbstring php7*-xml php7*-xmlrpc php7*-soap php7*-intl php7*-zip wordpress
	@systemctl reload apache2


# Полезные команды
# Проверка конфигурации apache: apache2ctl -t
# Установленные модули: apache2ctl -M
