#! /bin/sh
wget 'https://crest-tq.eveonline.com/industry/systems/' -O json/IndustrySystems.json
/usr/bin/python2.7 json/loadIndustry.py
rm json/IndustrySystems.json
