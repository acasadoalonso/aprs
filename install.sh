#!/bin/bash 
echo								#
echo "Installing the SGP 2D live tracking interface ...." 	#
echo								#
export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8		#
sudo apt-get install -y software-properties-common python-software-properties #
sudo rm /etc/apt/sources.list.d/ondre*				#
sudo add-apt-repository ppa:ondrej/php				#
echo								#
echo " lets update the operating system libraries  ...." 	#
echo								#
sudo apt-get update						#
sudo apt-get install -y language-pack-en-base 			# 
export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8		#
echo "export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 " >>~/.profile #
echo "export LD_LIBRARY_PATH=/usr/local/lib" >>~/.profile 	#
sudo apt-get -y upgrade						#
cd /var/www/public/main/libfap-1.5/deb				#
sudo dpkg -i lib*amd64.deb					#
echo								#
echo "Installing the packages required . (LAMP stack)..."	#
echo								#
cd /var/www/public/main						#
sudo apt-get install -y mysql-server mysql-client sqlite3	#
sudo apt-get install -y python-dev python-pip python-mysqldb    #
sudo apt-get install -y dos2unix libarchive-dev	 autoconf mc	#
sudo apt-get install -y pkg-config git	mutt			#
sudo apt-get install -y apache2 php php-mcrypt php-mysql php-cli #
sudo apt-get install -y php-mbstring php-gettext		#
sudo a2enmod rewrite						#
sudo phpendmod mcrypt						#
sudo phpendmod mbstring						#
sudo cat /etc/apache2/apache2.conf html.dir 	>>temp.conf	#
sudo echo "ServerName APRSLOG " >>temp.conf			#
sudo mv temp.conf /etc/apache2/apache2.conf			#
sudo service apache2 restart					#
echo								#
echo "Installing phpmyadmin  ... "				#
echo								#
#sudo apt-get install -y phpmyadmin 				#
#sudo service apache2 restart					#
sudo pip install ephem pytz geopy configparser			#
sudo npm install websocket socket.io request parsejson		#
if [ ! -d /etc/local ]						#
then								#
    sudo mkdir /etc/local					#
fi								#
echo								#
echo "Installing the templates needed  ...." 			#
echo								#
sudo cp config.template /etc/local/APRSconfig.ini		#
cd /var/www/public/						#
python genconfig.py						#
echo "CREATE DATABASE APRSLOG" | mysql 				#
mysql --database APRSLOG < main/DBschema.sql			#
echo								#
echo "Optional steps ... "					#
echo								#
cd main								#
mailcatcher --http-ip=0.0.0.0					#
cd sh	 							#
crontab <crontab.data						#
crontab -l 							#
if [ ! -d ~/src  ]						#
then								#
	mkdir ~/src   						#
	mkdir ~/src/APRSsrc					#
	ln -s /var/www/html/main ~/src/APRSsrc			#
fi								#
cp *.sh ~/src  							#
cd ..								#
cp *.py ~/src/APRSsrc						#
ls  -la ~/src 							#
if [ ! -d /nfs  ]						#
then								#
	sudo mkdir /nfs						#
	sudo mkdir /nfs/OGN					#
	sudo mkdir /nfs/OGN/SWdata				#
	sudo chown vagrant:vagrant /nfs/OGN/SWdata		#
	sudo chmod 777 /nfs/OGN/SWdata				#
	cd /var/www/public/					#
	sudo chown vagrant:vagrant *				# 
	sudo chmod 777 *					#
	sudo chown vagrant:vagrant */*				# 
	sudo chmod 777 */*					#
fi								#
cd								#
sudo dpkg-reconfigure tzdata					#
sudo apt-get -y dist-upgrade					#
mysqladmin -u root password ogn					#
sudo apt-get -y autoremove					#
touch APRSinstallation.done					#
echo								#
echo "========================================================================================================"	#
echo "Installation done ..."					#
echo "Review the configuration file on /etc/local ..."								#
echo "Review the configuration of the crontab and the shell scripts on ~/src " 					#
echo "In order to execute the APRSLOG data crawler execute:  bash ~/src/APSRlive.sh " 			#
echo "Check the placement of the RootDocument on APACHE2 ... needs to be /var/www/html				#
echo "If running in Windows under Virtual Box, run dos2unix on /var/www/html & ./main & ~/src			#
echo "Install phpmyadmin if needed !!!                                                                          #
echo "========================================================================================================"	#
echo								#
