CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'pswd1234';
GRANT ALL ON wordpress.* TO 'wordpress'@'localhost';
FLUSH PRIVILEGES;