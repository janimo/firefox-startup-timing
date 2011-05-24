#!/bin/bash

#Firefox extensions directory
EXTDIR=~/.mozilla/extensions/\{ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/

mkdir -p $EXTDIR

#"About:startup" extension location
XPIDIR=aboutstartup@glandium.org.xpi

#Default profile directory
PROFILEDIR=/home/jani/.mozilla/firefox/*.default/

#Logfile created by the extension
LOGFILE=$PROFILEDIR/startup.log

#Save original preferences
cp $PROFILEDIR/prefs.js .

rm -f $LOGFILE

#Set autoQuit option
cp user.js $PROFILEDIR

#Install extension
mv $XPIDIR $EXTDIR

#Quietly flush pagechace, dentries and inodes, to simulate a cold start
sudo sync && sudo sysctl -q -w vm.drop_caches=3
#Make sure generic system/desktop libs which are normally loaded are in the cache
gcalctool -s "42" >/dev/null

#Cold start
firefox 2>/dev/null

#Warm start 1
firefox 2>/dev/null

#Warm start 2
firefox 2>/dev/null

#Remove extension
mv $EXTDIR/$XPIDIR .

#Output the timing measurements
cat $LOGFILE

#Cleanup
rm $LOGFILE
rm $PROFILEDIR/user.js
mv prefs.js $PROFILEDIR/

