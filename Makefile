# -------------------------------- Пути к PHP -------------------------------- #
PHP70_CONF = /etc/php/7.0/fpm/pool.d/www.conf
PHP73_CONF = /etc/php/7.3/fpm/pool.d/www.conf

apache:
	@apt update
	@apt install -y apache2
	@systemctl start apache2
	@systemctl enable apache2

del_apache:
	@systemctl stop apache2
	@apt remove -y apache2
	@apt purge -y apache2

example:
	@cp -r ./www/example.ru /var/www
	@cp -r ./sites-available/* /etc/apache2/sites-available
	@a2ensite example.ru.conf
	@systemctl reload apache2

del_example:
	@rm -r /var/www/example.ru
	@rm /etc/apache2/sites-enabled/example.ru.conf
	@rm /etc/apache2/sites-available/example.ru.conf
	@systemctl reload apache2

php:
	@apt-get install software-properties-common -y
	@add-apt-repository -y ppa:ondrej/php
	@apt-get update -y
	@apt-get install php7.0 php7.0-fpm php7.0-mysql libapache2-mod-php7.0 libapache2-mod-fcgid -y
	@apt-get install php7.3 php7.3-fpm php7.3-mysql libapache2-mod-php7.3 -y
	@sed -i '/^;security.limit_extensions/s/;//g' $(PHP70_CONF)
	@sed -i '/^security.limit_extensions/s/$$/ .html .wsgi/g' $(PHP70_CONF)
	@sed -i '/^;listen.allowed_clients/s/;//g' $(PHP70_CONF)
	@sed -i '/^;security.limit_extensions/s/;//g' $(PHP73_CONF)
	@sed -i '/^security.limit_extensions/s/$$/ .html .wsgi/g' $(PHP73_CONF)
	@sed -i '/^;listen.allowed_clients/s/;//g' $(PHP73_CONF)
	@systemctl start php7.0-fpm
	@systemctl enable php7.0-fpm
	@systemctl start php7.3-fpm
	@systemctl enable php7.3-fpm
	@a2enmod actions fcgid alias proxy_fcgi
	@systemctl reload apache2

del_php:
	@systemctl stop php7.0-fpm
	@systemctl stop php7.3-fpm
	@apt-get remove --purge php7* -y
	@apt-get remove --purge php-common -y

php7ru:
	@cp -r ./www/php0.ru /var/www && cp -r ./www/php3.ru /var/www
	@cp -r ./sites-available/* /etc/apache2/sites-available
	@a2ensite php0.ru.conf && a2ensite php3.ru.conf
	@systemctl reload apache2

del_php7ru:
	@rm /etc/apache2/sites-enabled/php0.ru.conf
	@rm /etc/apache2/sites-available/php0.ru.conf
	@rm /etc/apache2/sites-enabled/php3.ru.conf
	@rm /etc/apache2/sites-available/php3.ru.conf
	@rm -r /var/www/php0.ru
	@rm -r /var/www/php3.ru
	@systemctl reload apache2


# Полезные команды
# Проверка конфигурации apache: apache2ctl -t
