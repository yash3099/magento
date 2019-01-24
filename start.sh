service mysql start 
( echo "CREATE DATABASE $DB;"; echo "CREATE USER $USER@localhost IDENTIFIED BY '$PASS'; "; echo "GRANT ALL ON magento.* TO $USER@localhost;" ; echo "FLUSH PRIVILEGES;" ; echo "exit" ; ) | mysql -u root --skip-password
/usr/sbin/apache2ctl -D FOREGROUND