CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'wordpressuser'@'*' IDENTIFIED BY 'password';
GRANT ALL ON wordpress.* TO 'wordpressuser'@'*';
FLUSH PRIVILEGES;