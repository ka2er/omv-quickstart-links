#!/bin/sh


sabnzbd_version="0.7.11"

/etc/init.d/SABnzbd stop

cd /opt

# backup old post-process
TMP_BACKUP=`mktemp -d`
cp -t $TMP_BACKUP SABnzbd/post-process/*

wget http://sourceforge.net/projects/sabnzbdplus/files/sabnzbdplus/$sabnzbd_version/SABnzbd-$sabnzbd_version-src.tar.gz/download
tar xzvf download
rm download
mkdir SABnzbd-$sabnzbd_version/post-process
mv $TMP_BACKUP/* SABnzbd-$sabnzbd_version/post-process/
mkdir SABnzbd-$sabnzbd_version/email/others
mv SABnzbd-$sabnzbd_version/email/*tmpl SABnzbd-$sabnzbd_version/email/others
mv SABnzbd-$sabnzbd_version/email/others/*-fr.tmpl SABnzbd-$sabnzbd_version/email
rm /opt/SABnzbd
ln -sf /opt/SABnzbd-$sabnzbd_version /opt/SABnzbd
chown -R sabnzbd:users SABnzbd
chown -R sabnzbd:users SABnzbd-$sabnzbd_version

/etc/init.d/SABnzbd start

rm -rf $TMP_BACKUP
