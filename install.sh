sudo apt-get install -y apache2 apache2-utils php libapache2-mod-php php-mysql php-curl php-
gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip mariadb-server mariadb-client

sudo apt install apache2 -y

sudo apt install wget
sudo wget https://wordpress.org/latest.tar.gz

sudo tar xzvf latest.tar.gz
sudo mkdir -p /var/www/html

sudo cp -r wordpress/* /var/www/html

sudo service apache2 restart

sudo service mysql restart

sudo chown -R www-data /var/www/html

sudo chmod -R 755 /var/www/html
