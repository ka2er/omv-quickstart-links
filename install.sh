#!/bin/bash

MYDOMAIN="EDIT_ME"  #ex: domain.fr
# 
install_dir="EDIT_ME"

# series directory
tv_dir="EDIT_ME"

# backup_dir
backup_dir="EDIT_ME"

mkdir -p $install_dir

script_path=$PWD
cd $install_dir

# add backports
echo "deb http://ftp.fr.debian.org/debian/ squeeze main non-free" >> /etc/apt/sources.list
echo "deb http://backports.debian.org/debian-backports squeeze-backports main" >> /etc/apt/sources.list
apt-get update

# utils
apt-get install less zsh vim sysstat htop curl locate


# sabnzbdplus
sabnzbd_version="0.7.10"

apt-get install python python-cheetah python-configobj python-feedparser python-support par2 python-openssl python-yenc unzip unrar python-dbus

wget http://sourceforge.net/projects/sabnzbdplus/files/sabnzbdplus/$sabnzbd_version/SABnzbd-$sabnzbd_version-src.tar.gz/download

tar xzvf download
rm download
ln -sf SABnzbd-$sabnzbd_version SABnzbd

mkdir -p /var/run/SABnzbd/
mkdir -p /var/log/SABnzbd/
mkdir -p /var/lib/SABnzbd/
mkdir -p /etc/sabnzbd/
touch /etc/sabnzbd/sabnzbd.ini

# keep only french templates
mkdir SABnzbd/email/others
mv SABnzbd/email/*tmpl SABnzbd/email/others
mv SABnzbd/email/others/*-fr.tmpl SABnzbd/email
mkdir SABnzbd/post-process

useradd -M -N -s /bin/false sabnzbd
cat $script_path/templates/init_script.sh | sed -e s/__service__/SABnzbd/g \
	-e s#__root__#$install_dir# \
	-e s#root#sabnzbd# \
	-e s#__args__#-d\ -f\ /etc/sabnzbd/sabnzbd.ini\ --pid\ /var/run/SABnzbd# > /etc/init.d/SABnzbd

chown -R sabnzbd:users SABnzbd
chown -R sabnzbd:users SABnzbd-$sabnzbd_version
chown -R sabnzbd:users /var/lib/SABnzbd/
chown -R sabnzbd:users /var/log/SABnzbd/
chown -R sabnzbd:users /var/run/SABnzbd/
chown sabnzbd:users /etc/sabnzbd/sabnzbd.ini
chown sabnzbd:users /etc/sabnzbd
chmod 755 /etc/sabnzbd

chmod 755 /etc/init.d/SABnzbd
update-rc.d SABnzbd defaults


# sickbeard - series
git clone git://github.com/midgetspy/Sick-Beard.git
mv Sick-Beard sickbeard

useradd -M -N -s /bin/false sickbeard
cp sickbeard/init.ubuntu /etc/init.d/sickbeard

echo "SB_OPTS='--config=/etc/sickbeard/config.ini --port=8081'" > /etc/default/sickbeard

mkdir /etc/sickbeard/
touch /etc/sickbeard/config.ini
chmod 666 /etc/sickbeard/config.ini
chmod 777 /etc/sickbeard/


cp sickbeard/autoProcessTV/sabToSickBeard.py SABnzbd/post-process/
cp sickbeard/autoProcessTV/autoProcessTV.py SABnzbd/post-process/
cp sickbeard/autoProcessTV/autoProcessTV.cfg.sample SABnzbd/post-process/autoProcessTV.cfg
chown -R sabnzbd:users SABnzbd/post-process/


chown -R sickbeard:users sickbeard
chown -R sickbeard:users /etc/default/sickbeard
chmod 755 /etc/init.d/sickbeard
update-rc.d sickbeard defaults

# subtitle auto
# check out periscope :
#apt-get install subversion
#svn checkout http://periscope.googlecode.com/svn/trunk/ periscope
# prepare python for install:
#apt-get install python-setuptools python-beautifulsoup
#cd periscope
#install periscope
#python setup.py install

#cd ../
#echo <<EOF > SickBeard/searchSubs.sh
#!/bin/sh
#echo Filename to process. $1
#echo Original filename... $2
#echo Show TVDB id........ $3
#echo Season number....... $4
#echo Episode number...... $5
#echo Episode air date.... $6
#echo ... will now pass the search info to periscope to snatch a subtitle
#/usr/local/bin/periscope "$1" -l fr -l en --force
#EOF

#chmod 755 SickBeard/searchSubs.sh
#chown sickbeard:nogroup SickBeard/searchSubs.sh

#echo "Please add to sickbeard/confi.ini extrascript to searchSubs.sh"


# subliminal - a fork of periscope
#
apt-get install git-core python-pip libxml2-dev libxslt1-dev gcc python-dev
pip install beautifulsoup4 guessit requests enzyme html5lib lxml
git clone https://github.com/Diaoul/subliminal.git
cd subliminal
python setup.py install
cd ../

# install cron
USER_ORIG=`logname`
crontab -u $USER_ORIG -l > /tmp/crontab.tmp
echo "0 1 * * * /usr/local/bin/subliminal -l en -l fr $tv_dir" >> /tmp/crontab.tmp
crontab -u $USER_ORIG /tmp/crontab.tmp
rm /tmp/crontab.tmp
su $USER_ORIG -c "mkdir -p /home/$USER_ORIG/.config/subliminal/"


# couchpotato - film
git clone git://github.com/RuudBurger/CouchPotatoServer.git
mv CouchPotatoServer couchpotato

useradd -M -N -s /bin/false couchpotato
mkdir -p /var/lib/couchpotato
chown couchpotato /var/lib/couchpotato
touch /etc/couchpotato
chown couchpotato /etc/couchpotato

cat couchpotato/init/ubuntu | sed -e s#/usr/local/sbin/CouchPotatoServer/#$install_dir/couchpotato/# \
	-e s/YOUR_USERNAME_HERE/couchpotato/ \
	-e s#--daemon#--daemon\ --config_file=/etc/couchpotato\ --data_dir=/var/lib/couchpotato# > /etc/init.d/couchpotato

chown -R couchpotato:users couchpotato

chmod 755 /etc/init.d/couchpotato
update-rc.d couchpotato defaults


# headphones - musique
# 
# utiliser ffmpeg pour encoder les flac egalement
# dans fichier config folder_ermissions=775
#
git clone git://github.com/rembo10/headphones.git headphones

useradd -M -N -s /bin/false headphones
mkdir -p /var/lib/headphones
chown headphones /var/lib/headphones
touch /etc/headphones
chown headphones /etc/headphones

cat headphones/init.ubuntu | sed -e s/application\ instance// \
	-e s#/usr/local/sbin#$install_dir# \
	-e s/root/headphones/ \
	-e s#Headphones.py\ -q#Headphones.py\ -q\ --datadir\ /var/lib/headphones\ --config\ /etc/headphones# \
	> /etc/init.d/headphones

chown -R headphones:users headphones

chmod 755 /etc/init.d/headphones
update-rc.d headphones defaults

# beets - music organizer
apt-get install python-dev python-setuptools python-pip imagemagick python-yaml
pip install flask
pip install pylast
pip install pyechonest
pip install beets

# subsonic
useradd -M -N -s /bin/false supersonic

apt-get install openjdk-6-jre maven2 openjdk-6-jdk lintian default-jre-headless


git clone http://github.com/Mach5/supersonic.git
cd supersonic

mvn -P full -pl subsonic-booter -am install 
mvn -P full -pl subsonic-main -am install 
mvn -P full -pl subsonic-installer-debian -am install

dpkg -i subsonic-installer-debian/target/supersonic-4.7.beta1.deb

#wget http://prdownloads.sourceforge.net/subsonic/subsonic-4.7.deb
#dpkg -i subsonic-4.7.deb
#rm subsonic-4.7.deb

#cat /etc/default/subsonic | sed -e s/=root/=subsonic/ > /etc/default/subsonic.tmp
#mv /etc/default/subsonic.tmp /etc/default/subsonic

cat /etc/default/supersonic | sed -e s/=root/=supersonic/ > /etc/default/supersonic.tmp
mv /etc/default/supersonic.tmp /etc/default/supersonic
cd ../

# automatic cover rename to folder.jpg
crontab -u $USER_ORIG -l > /tmp/crontab.tmp
echo "@daily bash -c 'while IFS= read -r img; do DIR=`dirname \"$img\"`; mv \"$img\" \"$DIR/folder.jpg\"; done < <(find /mnt/samba/son -iname \*jpg | grep -v folder.jpg)'" >> /tmp/crontab.tmp
crontab -u $USER_ORIG /tmp/crontab.tmp
rm /tmp/crontab.tmp


# shellinabox - ssh
sudo apt-get install build-essential fakeroot devscripts debhelper autotools-dev libssl-dev libpam0g-dev zlib1g-dev 

wget http://shellinabox.googlecode.com/files/shellinabox-2.14.tar.gz
tar xzvf shellinabox-2.14.tar.gz
cd shellinabox-2.14

dpkg-buildpackage -b
cd ..
sudo dpkg -i shellinabox*deb
rm shellinabox*deb


## ampache
echo "deb http://www.deb-multimedia.org squeeze main non-free" >> /etc/apt/sources.list
apt-get update
apt-get install deb-multimedia-keyring
apt-get update
apt-get install lame mp3splt flac ffmpeg

## fichier de conf ampache
#/usr/share/ampache/www/config/ampache.cfg.php
#transcode_flac  = true
# TODO ampache 

# greyhole : many disk only one share
apt-get install cifs-utils
wget --no-check-certificate https://raw.github.com/gist/1099419/mount_shares_locally
cat mount_shares_locally | sed -e s/your\ username/$USER_ORIG/ -e s/0660/0666/ -e s/0770/0777/ -e s/${gid}/100/ > /etc/init.d/mount_shares_locally
rm mount_shares_locally
chmod +x /etc/init.d/mount_shares_locally

echo "username=your_username\n
password=your_password\n
domain=HOME" > /home/$USER_ORIG/.smb_credentials

update-rc.d mount_shares_locally defaults

# unison is a must have for file synchronisation
apt-get install unison

# nginx
apt-get install nginx

cat $script_path/templates/nzb | sed -e s/DOMAIN/$MYDOMAIN/ > /etc/nginx/sites-available/nzb
ln -sf /etc/nginx/sites-available/nzb /etc/nginx/sites-enabled/nzb
cp $script_path/templates/maxupload.conf /etC/nginx/conf.d/


# TODO fastcgiparam

# SSL certs
apt-get install ssl-cert
mkdir -p /etc/nginx/conf
make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/nginx/conf/ssl.pem

# TODO PHP

# mod apache ports
cat /etc/apache2/sites-available/openmediavault-webgui | sed -e s/80/8000/ > /etc/apache2/sites-available/openmediavault-webgui.tmp
mv /etc/apache2/sites-available/openmediavault-webgui.tmp /etc/apache2/sites-available/openmediavault-webgui

cat /etc/apache2/ports.conf | sed -e s/80/8000/ > /etc/apache2/ports.conf.tmp
mv /etc/apache2/ports.conf.tmp /etc/apache2/ports.conf


## omv extrq plugins
wget -O omvplugin.deb 'http://packages.omv-plugins.org/pool/main/o/openmediavault-omvpluginsorg/openmediavault-omvpluginsorg_0.4~10.gbp5bae63_all.deb'
dpkg -i omvplugin.deb
rm omvplugin.deb

# install a server config cron backup
mkdir -p $backup_dir
chgrp users $backup_dir
chmod 775 $backup_dir
cd $script_path
crontab -u $USER_ORIG -l > /tmp/crontab.tmp
echo "0 1 * * * cd $backup_dir && /opt/bin/save-conf.sh" >> /tmp/crontab.tmp
crontab -u $USER_ORIG /tmp/crontab.tmp
rm /tmp/crontab.tmp

### rar crack
wget http://downloads.sourceforge.net/project/rarcrack/rarcrack-0.2/%5BUnnamed%20release%5D/rarcrack-0.2.tar.bz2
tar -xjf rarcrack-0.2.tar.bz2
cd rarcrack-0.2
apt-get install libxml2-dev
make

cp rarcrack /usr/local/bin
cd ../
rm -rf rarcrack-0.2*

echo -------------------------
echo Please Edit /opt/SABnzbd/post-process/autoProcessTV.cfg


################## OWNCLOUD #############

mkdir owncloud
cd owncloud

apt-get install php5 php5-gd php-xml-parser php5-intl
apt-get install php5-sqlite php5-mysql smbclient curl libcurl3 php5-curl
apt-get install spawn-fcgi

wget http://download.owncloud.org/community/owncloud-5.0.8.tar.bz2
tar xjvf owncloud-5.0.8.tar.bz2

chown -R www-data:www-data .
mv owncloud /var/www/
cd ../
rm -rf owncloud

## NGINX
 
mkdir /var/run/php-fastcgi

cat <<'EOF' > /usr/local/bin/php-fastcgi
#!/bin/bash

FASTCGI_USER=www-data
FASTCGI_GROUP=www-data
ADDRESS=127.0.0.1
PORT=9000
PIDFILE=/var/run/php-fastcgi/php-fastcgi.pid
CHILDREN=6
PHP5=/usr/bin/php5-cgi

/usr/bin/spawn-fcgi -a $ADDRESS -p $PORT -P $PIDFILE -C $CHILDREN -u $FASTCGI_USER -g $FASTCGI_GROUP -f $PHP5
EOF

chmod 755 /usr/local/bin/php-fastcgi

cat <<'EOF2' > /etc/init.d/php-fastcgi
#!/bin/bash

### BEGIN INIT INFO
# Provides:          php-fastcgi
# Required-Start:    $local_fs $network $syslog
# Required-Stop:     $local_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the php cgi server
# Description:       starts php cgi using start-stop-daemon
### END INIT INFO


PHP_SCRIPT=/usr/local/bin/php-fastcgi
FASTCGI_USER=www-data
FASTCGI_GROUP=www-data
PID_DIR=/var/run/php-fastcgi
PID_FILE=/var/run/php-fastcgi/php-fastcgi.pid
RET_VAL=0

case "$1" in
    start)
      if [[ ! -d $PID_DIR ]]
      then
        mkdir $PID_DIR
        chown $FASTCGI_USER:$FASTCGI_GROUP $PID_DIR
        chmod 0770 $PID_DIR
      fi
      if [[ -r $PID_FILE ]]
      then
        echo "php-fastcgi already running with PID `cat $PID_FILE`"
        RET_VAL=1
      else
        $PHP_SCRIPT
        RET_VAL=$?
      fi
  ;;
    stop)
      if [[ -r $PID_FILE ]]
      then
        kill `cat $PID_FILE`
        rm $PID_FILE
        RET_VAL=$?
      else
        echo "Could not find PID file $PID_FILE"
        RET_VAL=1
      fi
  ;;
    restart)
      if [[ -r $PID_FILE ]]
      then
        kill `cat $PID_FILE`
        rm $PID_FILE
        RET_VAL=$?
      else
        echo "Could not find PID file $PID_FILE"
      fi
      $PHP_SCRIPT
      RET_VAL=$?
  ;;
    status)
      if [[ -r $PID_FILE ]]
      then
        echo "php-fastcgi running with PID `cat $PID_FILE`"
        RET_VAL=$?
      else
        echo "Could not find PID file $PID_FILE, php-fastcgi does not appear to be running"
      fi
  ;;
    *)
      echo "Usage: php-fastcgi {start|stop|restart|status}"
      RET_VAL=1
  ;;
esac
exit $RET_VAL
EOF2

chmod +x /etc/init.d/php-fastcgi
update-rc.d php-fastcgi defaults

# en_US-UTF-8
dpkg-reconfigure locales

cat $script_path/templates/owncloud | sed -e s/DOMAIN/$MYDOMAIN/ > /etc/nginx/sites-available/owncloud
ln -sf /etc/nginx/sites-available/owncloud /etc/nginx/sites-enabled/owncloud

