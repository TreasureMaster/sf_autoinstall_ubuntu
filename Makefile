

apache:
	@apt update
	@apt install -y apache2
	@systemctl start apache2
	@systemctl enable apache2

del_apache:
	@systemctl stop apache2
	@apt remove -y apache2
	@apt purge -y apache2
