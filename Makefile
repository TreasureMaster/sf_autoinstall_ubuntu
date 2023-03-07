

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
	@ln -s /etc/apache2/sites-available/example.ru.conf /etc/apache2/sites-enabled/example.ru.conf
	@systemctl reload apache2

del_example:
	@rm -r /var/www/example.ru
	@rm /etc/apache2/sites-enabled/example.ru.conf
	@rm /etc/apache2/sites-available/example.ru.conf
	@systemctl reload apache2

php:
	@apt-get install software-properties-common -y
	@add-apt-repository ppa:ondrej/php
	@apt-get update -y
	@apt-get install php7.0 php7.0-fpm php7.0-mysql libapache2-mod-php7.0 libapache2-mod-fcgid -y
	@apt-get install php7.3 php7.3-fpm php7.3-mysql libapache2-mod-php7.3 -y
	@systemctl start php7.0-fpm
	@systemctl enable php7.0-fpm
	@systemctl start php7.3-fpm
	@systemctl enable php7.3-fpm
	@a2enmod actions fcgid alias proxy_fcgi
	@systemctl reload apache2

del_php:
	@systemctl stop php7.0-fpm
	@systemctl stop php7.3-fpm
	@apt-get remove --purge php7*


# Полезные команды
# Проверка конфигурации apache: apache2ctl -t
