#!/bin/bash

install_dir="EDIT_ME"

mkdir -p $install_dir

script_path=$PWD
cd $install_dir

# utils
apt-get install zsh vim sysstats htops


# sabnzbdplus
sabnzbd_version="0.6.14"

apt-get install python python-cheetah python-configobj python-feedparser python-support par2 python-openssl python-yenc unzip unrar python-dbus

wget http://sourceforge.net/projects/sabnzbdplus/files/sabnzbdplus/sabnzbd-$sabnzbd_version/SABnzbd-$sabnzbd_version-src.tar.gz/download
tar xzvf download
rm download
ln -sf SABnzbd-$sabnzbd_version SABnzbd

mkdir -p /var/run/SABnzbd/
mkdir -p /var/log/SABnzbd/
mkdir -p /var/lib/SABnzbd/
mkdir -p /etc/sabnzbd/

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
wget https://github.com/midgetspy/Sick-Beard/tarball/master --no-check-certificate
tar xzf master
mv midge* SickBeard
rm master

useradd -M -N -s /bin/false sickbeard
cat SickBeard/init.ubuntu | sed -e s/SICKBEARD_USER/sickbeard/ \
	-e s#PATH_TO_SICKBEARD_DIRECTORY#$install_dir/SickBeard# \
	-e s#~/.sickbeard#/var/lib/sickbeard# > /etc/init.d/sickbeard	

cp SickBeard/autoProcessTV/sabToSickBeard.py SABnzbd/post-process/
cp SickBeard/autoProcessTV/autoProcessTV.py SABnzbd/post-process/
cp SickBeard/autoProcessTV/autoProcessTV.cfg.sample SABnzbd/post-process/autoProcessTV.cfg
chown -R sabnzbd:users SABnzbd/post-process/

chown -R sickbeard:users SickBeard

chmod 755 /etc/init.d/sickbeard
update-rc.d sickbeard defaults


# couchpotato - film
wget https://github.com/RuudBurger/CouchPotato/tarball/master --no-check-certificate
tar xzf master
mv Ruu* couchpotato
rm master

useradd -M -N -s /bin/false couchpotato
mkdir -p /var/lib/couchpotato
chown couchpotato /var/lib/couchpotato
touch /etc/couchpotato
chown couchpotato /etc/couchpotato

cp couchpotato/initd.ubuntu /etc/init.d/couchpotato
cat couchpotato/default.ubuntu | sed -e s#/opt#$install_dir# \
	-e s/=0/=1/ \
	-e s/RUN_AS=/RUN_AS=couchpotato/ \
	-e s#CONFIG=#CONFIG=/etc/couchpotato# \
	-e s#DATADIR=#DATADIR=/var/lib/couchpotato# > /etc/default/couchpotato

chown -R couchpotato:users couchpotato

chmod 755 /etc/init.d/couchpotato
update-rc.d couchpotato defaults


# headphones - musique
wget https://github.com/rembo10/headphones/tarball/master --no-check-certificate
tar xzf master
mv rem* headphones
rm master

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


# apache redirect
a2enmod redirect
#touch /etc/apache2/conf.d/redirect +redirect RULES
echo "Listen 80" >> /etc/apache2/ports.conf

# unison is a must have for file synchronisation
apt-get install unison
