

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
	@cp -r ./www /var/www
	@cp -r ./sites-available /etc/apache2/sites-available
	@ln -s /etc/apache2/sites-available/example.ru.conf /etc/apache2/sites-enabled/example.ru.conf
	@systemctl reload apache2
