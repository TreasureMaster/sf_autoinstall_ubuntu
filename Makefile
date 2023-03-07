

apache:
	@apt update
	@apt install -y apache2
	@systemctl start apache2
	@systemctl enable apache2

del_apache:
	@apt remove apache2
	@apt purge apache2
