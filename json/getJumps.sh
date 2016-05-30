#! /bin/sh
wget 'https://api.eveonline.com//map/Jumps.xml.aspx' -O json/Jumps.xml
/usr/bin/python2.7 json/loadJumps.py
rm Jumps.xml
